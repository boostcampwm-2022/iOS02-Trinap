//
//  EditPhotographerViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

typealias EditPhotographerDataSource = [PhotographerSection: [PhotographerSection.Item]]

final class EditPhotographerViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let tabState: Observable<Int>
        let isEditable: Observable<Bool>
        let selectedPicture: Observable<[Int]>
        let deleteTrigger: Observable<Void>
    }
    
    struct Output {
        let dataSource: Driver<[EditPhotographerDataSource]>
    }
    
    // MARK: - Properties
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchPhotographerUseCase: FetchPhotographerUseCase
    private let fetchReviewUseCase: FetchReviewUseCase
    private let editPortfolioPictureUseCase: EditPortfolioPictureUseCase
    private let mapRepository: MapRepository
    
    var disposeBag = DisposeBag()
    
    private let reloadTrigger = BehaviorSubject<Void>(value: ())
    // MARK: - Initializer
    init(
        fetchUserUseCase: FetchUserUseCase,
        fetchPhotographerUseCase: FetchPhotographerUseCase,
        fetchReviewUseCase: FetchReviewUseCase,
        editPortfolioPictureUseCase: EditPortfolioPictureUseCase,
        mapRepository: MapRepository
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchPhotographerUseCase = fetchPhotographerUseCase
        self.fetchReviewUseCase = fetchReviewUseCase
        self.editPortfolioPictureUseCase = editPortfolioPictureUseCase
        self.mapRepository = mapRepository
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .map { _ in }
            .bind(to: reloadTrigger)
            .disposed(by: disposeBag)
        
        let reviewInformation = self.reloadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchReviews()
            }
            .share()
        
        let photographer = self.reloadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchPhotographer()
            }
            .share()
        
        let dataSource = Observable.combineLatest(input.isEditable, input.tabState, photographer, reviewInformation)
            .map { [weak self] editable, section, photographer, review -> [EditPhotographerDataSource] in
                guard let self else { return [] }
                
                return self.mappingDataSource(isEditable: editable, state: section, photographer: photographer, review: review)
            }
        
        input.deleteTrigger
            .withLatestFrom(Observable.combineLatest(photographer, input.selectedPicture))
            .flatMap { photographer, indexs in
                return self.editPortfolioPictureUseCase.delete(
                    photographer: photographer.toPhotographer(),
                    indices: indexs)
            }
            .bind(to: reloadTrigger)
            .disposed(by: disposeBag)
        
        return Output(dataSource: dataSource.asDriver(onErrorJustReturn: []))
    }
}

extension EditPhotographerViewModel {
    
    private func fetchPhotographer() -> Observable<PhotographerUser> {
        return self.fetchUserUseCase.fetchUserInfo()
            .flatMap { user in
                self.fetchPhotographerUseCase.fetch(photographerId: user.userId)
                    .flatMap { photographer in
                        return self.mapRepository.fetchLocationName(
                            using: Coordinate(lat: photographer.latitude, lng: photographer.latitude)
                        )
                        .map { location in
                            return PhotographerUser(user: user, photographer: photographer, location: location)
                        }
                    }
            }
    }
    
    private func fetchReviews() -> Observable<ReviewInformation> {
        let summary = self.fetchReviewUseCase.fetchAverageReview(photographerId: nil)
        let reviews = self.fetchReviewUseCase.fetchReviews(photographerUserId: nil)
        return Observable.zip(summary, reviews)
            .map { summary, reviews in
                return ReviewInformation(summary: summary, reviews: reviews)
            }
    }
    
    private func mappingDataSource(isEditable: Bool, state: Int, photographer: PhotographerUser, review: ReviewInformation) -> [EditPhotographerDataSource] {
        
        switch state {
        case 0:
            return [mappingProfileDataSource(photographer: photographer)] + [mappingPictureDataSource(isEditable: isEditable, photographer: photographer)]
        case 1:
            return [mappingProfileDataSource(photographer: photographer)] + [mappingDetailDataSource(photographer: photographer)]
        case 2:
            return [mappingProfileDataSource(photographer: photographer)] + mappingReviewDataSource(review: review)
        default:
            return []
        }
    }
    
    private func updatePictureState(isEditable: Bool, pictures: [Picture?]) -> [Picture?] {
        return pictures.map { picture in
            return Picture(isEditable: isEditable, picture: picture?.picture)
        }
    }
}

// MARK: - MappingDataSource
extension EditPhotographerViewModel {
    
    private func mappingProfileDataSource(photographer: PhotographerUser) -> EditPhotographerDataSource {
        return [PhotographerSection.profile: [PhotographerSection.Item.profile(photographer)]]
    }
    
    private func mappingPictureDataSource(isEditable: Bool, photographer: PhotographerUser) -> EditPhotographerDataSource {
        return [PhotographerSection.photo: updatePictureState(isEditable: isEditable, pictures: photographer.pictures).map { PhotographerSection.Item.photo($0) } ]
    }
    
    private func mappingDetailDataSource(photographer: PhotographerUser) -> EditPhotographerDataSource {
        return [PhotographerSection.detail: [PhotographerSection.Item.detail(photographer)]]
    }
    
    private func mappingReviewDataSource(review: ReviewInformation) -> [EditPhotographerDataSource] {
        return [ [.detail: [.summaryReview(review.summary)]] ] +
            [ [.review: review.reviews.map { PhotographerSection.Item.review($0) } ] ]
    }
}

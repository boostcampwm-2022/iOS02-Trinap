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

typealias PhotographerDataSource = [PhotographerSection: [PhotographerSection.Item]]

final class EditPhotographerViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let tabState: Observable<Int>
        let isEditable: Observable<Bool>
        let selectedPicture: Observable<[Int]>
        let uploadImage: Observable<Data>
        let deleteTrigger: Observable<Void>
        let backButtonTap: Signal<Void>
    }
    
    struct Output {
        let dataSource: Driver<[PhotographerDataSource]>
    }
    
    // MARK: - Properties
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchPhotographerUseCase: FetchPhotographerUseCase
    private let fetchReviewUseCase: FetchReviewUseCase
    private let editPortfolioPictureUseCase: EditPortfolioPictureUseCase
    private let uploadImageUseCase: UploadImageUseCase
    private let mapRepository: MapRepository
    weak var coordinator: MyPageCoordinator?
    
    var disposeBag = DisposeBag()
    
    private let reloadTrigger = PublishSubject<Void>()
    
    // MARK: - Initializer
    init(
        fetchUserUseCase: FetchUserUseCase,
        fetchPhotographerUseCase: FetchPhotographerUseCase,
        fetchReviewUseCase: FetchReviewUseCase,
        editPortfolioPictureUseCase: EditPortfolioPictureUseCase,
        uploadImageUseCase: UploadImageUseCase,
        mapRepository: MapRepository,
        coordinator: MyPageCoordinator?
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchPhotographerUseCase = fetchPhotographerUseCase
        self.fetchReviewUseCase = fetchReviewUseCase
        self.editPortfolioPictureUseCase = editPortfolioPictureUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.mapRepository = mapRepository
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .map { _ in }
            .bind(to: reloadTrigger)
            .disposed(by: disposeBag)
        
        let photographer = self.reloadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchPhotographer()
            }
            .share()
        
        let reviewInformation = self.reloadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchReviews()
            }
            .share()
        
        input.uploadImage
            .withUnretained(self)
            .withLatestFrom(photographer, resultSelector: { args, photographer in
                let (owner, image) = args
                return owner.updatePortfolioImage(photographer: photographer, image: image)
            })
            .flatMap { $0 }
            .bind(to: reloadTrigger)
            .disposed(by: disposeBag)
            
        
        input.deleteTrigger
            .withLatestFrom(Observable.combineLatest(photographer, input.selectedPicture))
            .withUnretained(self)
            .flatMap { owner, arg in
                let (photographer, indexs) = arg
                return owner.editPortfolioPictureUseCase.delete(
                    photographer: photographer.toPhotographer(),
                    indices: indexs
                )
            }
            .bind(to: reloadTrigger)
            .disposed(by: disposeBag)
        
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        let dataSource = Observable.combineLatest(
            input.isEditable,
            input.tabState,
            photographer,
            reviewInformation
        )
            .withUnretained(self)
            .map { owner, arg in
                let (editable, section, photographer, review) = arg
                
                return owner.mappingDataSource(
                    isEditable: editable,
                    state: section,
                    photographer: photographer,
                    review: review
                )
            }
        
        return Output(dataSource: dataSource.asDriver(onErrorJustReturn: []))
    }
    
    private func updatePortfolioImage(photographer: PhotographerUser, image: Data) -> Observable<Void> {
        return self.editPortfolioPictureUseCase.add(
            photographerId: photographer.photographerId,
            currentPictures: photographer.pictures.compactMap { $0?.picture },
            pictureData: image
        )
    }
}

extension EditPhotographerViewModel {
    
    private func fetchPhotographer() -> Observable<PhotographerUser> {
        return self.fetchUserUseCase.fetchUserInfo()
            .withUnretained(self)
            .flatMap { owner, user in
                owner.fetchPhotographerUseCase.fetch(photographerUserId: user.userId)
                    .withUnretained(self)
                    .flatMap { owner, photographer in
                        owner.mapRepository.fetchLocationName(
                            using: Coordinate(lat: photographer.latitude, lng: photographer.longitude)
                        )
                        .map { location in
                            var photographerUser = PhotographerUser(user: user, photographer: photographer, location: location)
                            
                            if !photographer.pictures.isEmpty {
                                photographerUser.pictures.insert(nil, at: 0)
                            }
                            
                            return photographerUser
                        }
                    }
            }
    }
    
    private func fetchReviews() -> Observable<ReviewInformation> {
        let summary = self.fetchReviewUseCase.fetchAverageReview(photographerUserId: nil)
        let reviews = self.fetchReviewUseCase.fetchReviews(photographerUserId: nil)
        return Observable.zip(summary, reviews)
            .map { summary, reviews in
                guard !summary.rating.isNaN
                else {
                    return ReviewInformation(
                        summary: ReviewSummary(
                            rating: 0.0,
                            count: summary.count
                        ),
                        reviews: reviews
                    )
                }
                return ReviewInformation(summary: summary, reviews: reviews)
            }
    }
    
    private func mappingDataSource(isEditable: Bool, state: Int, photographer: PhotographerUser, review: ReviewInformation) -> [PhotographerDataSource] {
        
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
private extension EditPhotographerViewModel {
    
    func mappingProfileDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.profile: [PhotographerSection.Item.profile(photographer)]]
    }
    
    func mappingPictureDataSource(isEditable: Bool, photographer: PhotographerUser) -> PhotographerDataSource {
        if photographer.pictures.isEmpty {
            return [PhotographerSection.photo: []]
        }
        
        return [PhotographerSection.photo: updatePictureState(isEditable: isEditable, pictures: photographer.pictures).map { PhotographerSection.Item.photo($0) } ]
    }
    
    func mappingDetailDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        guard photographer.introduction != nil else {
            return [PhotographerSection.detail: []]
        }
        return [PhotographerSection.detail: [PhotographerSection.Item.detail(photographer)]]
    }
    
    func mappingReviewDataSource(review: ReviewInformation) -> [PhotographerDataSource] {
        if review.reviews.isEmpty {
            return [[PhotographerSection.review: []]]
        }
        return [ [.detail: [.summaryReview(review.summary)]] ] +
        [ [.review: review.reviews.map { PhotographerSection.Item.review($0) } ] ]
    }
}

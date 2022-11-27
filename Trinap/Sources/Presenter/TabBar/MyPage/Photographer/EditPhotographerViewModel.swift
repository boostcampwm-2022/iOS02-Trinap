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
    }
    
    struct Output {
        let dataSource: Driver<[EditPhotographerDataSource]>
    }
    
    // MARK: - Properties
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchPhotographerUseCase: FetchPhotographerUseCase
    private let fetchReviewUseCase: FetchReviewUseCase
    private let mapRepository: MapRepository
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(
        fetchUserUseCase: FetchUserUseCase,
        fetchPhotographerUseCase: FetchPhotographerUseCase,
        fetchReviewUseCase: FetchReviewUseCase,
        mapRepository: MapRepository
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchPhotographerUseCase = fetchPhotographerUseCase
        self.fetchReviewUseCase = fetchReviewUseCase
        self.mapRepository = mapRepository
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        let photograhper = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchPhotographer()
            }
            .share()
        
        let dataSource = Observable.combineLatest(input.isEditable, input.tabState, photograhper)
            .map { editable, section, photographer in
                switch section {
                case 0:
                    return photographer.toProfileDataSource(isEditable: editable)
                case 1:
                    return photographer.toDetailDataSource()
                default:
                    return photographer.toReviewDataSource()
                }
            }
        return Output(dataSource: dataSource.asDriver(onErrorJustReturn: []))
    }
}

extension EditPhotographerViewModel {
    
    private func fetchPhotographer() -> Observable<EditDetailPhotographerInformation> {
        return self.fetchUserUseCase.fetchUserInfo()
            .flatMap { user in
                self.fetchPhotographerUseCase.fetch(photographerId: user.userId)
                    .flatMap { photographer in
                        return self.mapRepository.fetchLocationName(
                            using: Coordinate(lat: photographer.latitude, lng: photographer.latitude)
                        )
                        .flatMap { location in
                            return self.fetchReviews(photographerUserId: photographer.photographerUserId)
                                .map { reviewInformation in
                                    return EditDetailPhotographerInformation(
                                        photographerProfile: PhotographerProfile(
                                            photographerId: photographer.photographerId,
                                            photographerUserId: photographer.photographerUserId,
                                            nickname: user.nickname,
                                            profielImage: user.profileImage,
                                            location: location,
                                            tags: photographer.tags,
                                            pricePerHalfHour: photographer.pricePerHalfHour
                                        ),
                                        introduction: PhotographerDetailIntroduction(introduction: photographer.introduction, pricePerHalfHour: photographer.pricePerHalfHour),
                                        pictures: [nil] + photographer.pictures.map { Picture(isEditable: false, profileImage: URL(string: $0)) },
                                        review: reviewInformation)
                                }
                        }
                    }
            }
    }
    
    private func fetchReviews(photographerUserId: String) -> Observable<ReviewInformation> {
        let summary = self.fetchReviewUseCase.fetchAverageReview(photographerId: photographerUserId)
        let reviews = self.fetchReviewUseCase.fetchReviews(photographerId: photographerUserId)
        return Observable.zip(summary, reviews)
            .map { summary, reviews in
                return ReviewInformation(summary: summary, reviews: reviews)
            }
    }
    
    private func mappingDataSource(isEditable: Bool, state: Int, photographer: EditDetailPhotographerInformation) -> [EditPhotographerDataSource] {
        
        switch state {
        case 0:
            return photographer.toProfileDataSource(isEditable: false)
        case 1:
            return photographer.toDetailDataSource()
        case 2:
            return photographer.toReviewDataSource()
        default:
            return []
        }
    }
}


//  PhotographerDetailViewModel.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class PhotographerDetailViewModel: ViewModelType {

    struct Input {
        let viewWillAppear: Observable<Bool>
        let tabState: Observable<Int>
//        let calendarTrigger: Observable<Void>
//        let confirmTrigger: Observable<Void>
    }

    struct Output {
        let dataSource: Driver<[PhotographerDataSource]>
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()

    //TODO: PhotographerUser로 반환하는 UseCase 만들어서 바로 받아오도록 변경
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchPhotographerUseCase: FetchPhotographerUseCase
    private let fetchReviewUseCase: FetchReviewUseCase
    private let mapRepository: MapRepository
    
    private let reloadTrigger = BehaviorSubject<Void>(value: ())
    
    // MARK: - Initializer
    init(
        fetchUserUseCase: FetchUserUseCase,
        fetchPhotographerUseCase: FetchPhotographerUseCase,
        fetchReviewUseCase: FetchReviewUseCase,
        mapRepository: MapRepository,
        userId: String,
        searchCoordinate: Coordinate,
        coordinator: MainCoordinator
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchPhotographerUseCase = fetchPhotographerUseCase
        self.fetchReviewUseCase = fetchReviewUseCase
        self.mapRepository = mapRepository
        self.coordiantor = coordinator
        self.searchCoordinate = searchCoordinate
        self.userId = userId
    }

    // MARK: - Initializer

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
        
        let photographer = self.reloadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchPhotographer()
            }
            .share()
        
        let dataSource = Observable.combineLatest(input.tabState, photographer, reviewInformation)
            .map { [weak self] section, photographer, review -> [PhotographerDataSource] in
                guard let self else { return [] }
                
                return self.mappingDataSource(isEditable: false, state: section, photographer: photographer, review: review)
            }

        return Output(dataSource: dataSource.asDriver(onErrorJustReturn: []))
    }
}


extension PhotographerDetailViewModel {
    
    private func fetchPhotographer() -> Observable<PhotographerUser> {
        return self.fetchUserUseCase.fetchUserInfo(userId: userId)
            .flatMap { user in
                self.fetchPhotographerUseCase.fetch(photographerUserId: user.userId)
                    .flatMap { photographer in
                        return self.mapRepository.fetchLocationName(
                            using: Coordinate(lat: photographer.latitude, lng: photographer.latitude)
                        )
                        .map { location in
                            var photographer = PhotographerUser(user: user, photographer: photographer, location: location)
                            photographer.pictures.removeFirst()
                            return photographer
                        }
                    }
            }
    }
    
    private func fetchReviews() -> Observable<ReviewInformation> {
        let summary = self.fetchReviewUseCase.fetchAverageReview(photographerId: nil)
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
extension PhotographerDetailViewModel {
    
    private func mappingProfileDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.profile: [PhotographerSection.Item.profile(photographer)]]
    }
    
    private func mappingPictureDataSource(isEditable: Bool, photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.photo: updatePictureState(isEditable: isEditable, pictures: photographer.pictures).map { PhotographerSection.Item.photo($0) } ]
    }
    
    private func mappingDetailDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.detail: [PhotographerSection.Item.detail(photographer)]]
    }
    
    private func mappingReviewDataSource(review: ReviewInformation) -> [PhotographerDataSource] {
        return [ [.detail: [.summaryReview(review.summary)]] ] +
            [ [.review: review.reviews.map { PhotographerSection.Item.review($0) } ] ]
    }
}

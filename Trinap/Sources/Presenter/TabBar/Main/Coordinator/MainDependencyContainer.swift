//
//  MainDependencyContainer.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import FirestoreService

final class MainDependencyContainer {
    
    // MARK: Properties
    let firestoreService: FireStoreService
    let photographerRepository: PhotographerRepository
    let mapRepository: MapRepository
    let reviewRepository: ReviewRepository
    let userRepository: UserRepository
    let reservationRepository: ReservationRepository
    
    weak var mainCoordinator: MainCoordinator?
    
    // MARK: Initializers
    init(mainCoordinator: MainCoordinator?) {
        self.firestoreService = DefaultFireStoreService()
        self.mainCoordinator = mainCoordinator
        self.photographerRepository = DefaultPhotographerRepository()
        self.mapRepository = DefaultMapRepository()
        self.reviewRepository = DefaultReviewRepository()
        self.userRepository = DefaultUserRepository()
        self.reservationRepository = DefaultReservationRepository(firebaseStoreService: firestoreService)
    }
    
    // MARK: PhotographerPreviewList
    func makePhotographerListViewController() -> PhotographerListViewController {
        let viewModel = makePhotographerListViewModel()
        return PhotographerListViewController(viewModel: viewModel)
    }
    
    private func makePhotographerListViewModel() -> PhotographerListViewModel {
        return PhotographerListViewModel(
            previewsUseCase: makePreviewsUseCase(),
            fetchCurrentLocationUseCase: makeFetchCurrentLocationUseCase(),
            coordinator: mainCoordinator
        )
    }
    
    private func makePreviewsUseCase() -> FetchPhotographerPreviewsUseCase {
        return DefaultFetchPhotographerPreviewsUseCase(
            photographerRepository: photographerRepository,
            mapRepository: mapRepository,
            userRepository: userRepository,
            reviewRepository: reviewRepository
        )
    }
    
    private func makeFetchCurrentLocationUseCase() -> FetchCurrentLocationUseCase {
        return DefaultFetchCurrentLocationUseCase(mapRepository: mapRepository)
    }
    
    // MARK: PhotographerDetail
    func makePhotographerDetailViewController(
        userId: String,
        searchCoordinate: Coordinate
    ) -> PhotographerDetailViewController {
        let viewModel = makePhotographerDetailViewModel(
            userId: userId,
            searchCoordinate: searchCoordinate
        )
        return PhotographerDetailViewController(viewModel: viewModel)
    }
    
    private func makePhotographerDetailViewModel(
        userId: String,
        searchCoordinate: Coordinate
    ) -> PhotographerDetailViewModel {
        return PhotographerDetailViewModel(
            fetchUserUseCase: makeFetchUserUseCase(),
            fetchPhotographerUseCase: makeFetchPhotographerUseCase(),
            fetchReviewUseCase: makeFetchReviewUseCase(),
            createReservationUseCase: makeCreateReservationUseCase(),
            mapRepository: mapRepository,
            userId: userId,
            searchCoordinate: searchCoordinate,
            coordinator: mainCoordinator
        )
    }
    
    private func makeFetchUserUseCase() -> FetchUserUseCase {
        return DefaultFetchUserUseCase(userRepository: userRepository)
    }
    
    private func makeFetchPhotographerUseCase() -> FetchPhotographerUseCase {
        return DefaultFetchPhotographerUseCase(photographerRespository: photographerRepository)
    }
    
    private func makeFetchReviewUseCase() -> FetchReviewUseCase {
        return DefaultFetchReviewUseCase(
            reviewRepositry: reviewRepository,
            userRepository: userRepository,
            photographerRepository: photographerRepository
        )
    }
    
    private func makeCreateReservationUseCase() -> CreateReservationUseCase {
        return DefaultCreateReservationUseCase(reservationRepository: reservationRepository)
    }
}

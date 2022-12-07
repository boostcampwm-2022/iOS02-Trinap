//
//  ReservationDependencyContainer.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import FirestoreService

final class ReservationDependencyContainer {
    
    // MARK: - Long Lived
    let firestoreService: FireStoreService
    let reservationRepository: ReservationRepository
    let userRepository: UserRepository

    weak var reservationCoordinator: ReservationCoordinator?
    
    init(reservationCoordinator: ReservationCoordinator?) {
        self.firestoreService = DefaultFireStoreService()
        self.reservationCoordinator = reservationCoordinator
        
        self.reservationRepository = DefaultReservationRepository(firebaseStoreService: firestoreService)
        self.userRepository = DefaultUserRepository(firestoreService: firestoreService)
    }
    
    // MARK: - PreviewList
    func makeReservationPreviewListViewController() -> ReservationPreviewListViewController {
        let viewModel = makeReservationPreviewListViewModel()
        
        return ReservationPreviewListViewController(viewModel: viewModel)
    }
    
    private func makeReservationPreviewListViewModel() -> ReservationPreviewListViewModel {
        let fetchReservationPreviewsUseCase = makeFetchReservationPreviewsUseCase()
        
        return ReservationPreviewListViewModel(
            coordinator: reservationCoordinator,
            fetchReservationPreviewsUseCase: fetchReservationPreviewsUseCase
        )
    }
    
    private func makeFetchReservationPreviewsUseCase() -> FetchReservationPreviewsUseCase {
        return DefaultFetchReservationPreviewsUseCase(
            reservationRepository: reservationRepository,
            userRepository: userRepository
        )
    }
    
    // MARK: - Detail
    func makeReservationDetailViewController(reservationId: String) -> ReservationDetailViewController {
        let viewModel = makeReservationDetailViewModel(reservationId: reservationId)
        
        return ReservationDetailViewController(viewModel: viewModel)
    }
    
    private func makeReservationDetailViewModel(reservationId: String) -> ReservationDetailViewModel {
        let fetchReservationUseCase = makeFetchReservationUseCase()
        let reservationUserTypeUseCase = makeReservationUserTypeUseCase()
        
        return ReservationDetailViewModel(
            reservationCoordinator: reservationCoordinator,
            fetchReservationUseCase: fetchReservationUseCase,
            fetchReservationUserTypeUseCase: reservationUserTypeUseCase,
            reservationId: reservationId,
            reservationStatusFactory: self
        )
    }
    
    private func makeFetchReservationUseCase() -> FetchReservationUseCase {
        let mapRepository = makeMapRepository()
        
        return DefaultFetchReservationUseCase(
            reservationRepository: reservationRepository,
            userRepository: userRepository,
            mapRepository: mapRepository
        )
    }
    
    private func makeReservationUserTypeUseCase() -> FetchReservationUserTypeUseCase {
        return DefaultFetchReservationUserTypeUseCase(reservationRepository: reservationRepository)
    }
    
    private func makeMapRepository() -> MapRepository {
        return DefaultMapRepository()
    }
    
    // MARK: - Reservation Create Review
    func makeCreateReviewViewController(photographerUserId: String) -> CreateReviewViewController {
        let viewModel = makeCreateReviewViewModel(photographerUserId: photographerUserId)
        
        return CreateReviewViewController(viewModel: viewModel)
    }
    
    private func makeCreateReviewViewModel(photographerUserId: String) -> CreateReviewViewModel {
        let createReviewUseCase = makeCreateReviewUseCase()
        
        return CreateReviewViewModel(
            photographerId: photographerUserId,
            createReviewUseCase: createReviewUseCase
        )
    }
    
    private func makeCreateReviewUseCase() -> CreateReviewUseCase {
        let repository = makeReviewRepository()
        
        return DefaultCreateReviewUseCase(reviewRepository: repository)
    }
    
    private func makeReviewRepository() -> ReviewRepository {
        return DefaultReviewRepository()
    }
    
    // MARK: - Customer Review List
    func makeCustomerReviewListViewController(creatorUser: User) -> CustomerReviewListViewController {
        let viewModel = makeCustomerReviewListViewModel(creatorUser: creatorUser)
        
        return CustomerReviewListViewController(viewModel: viewModel)
    }
    
    private func makeCustomerReviewListViewModel(creatorUser: User) -> CustomerReviewListViewModel {
        let fetchReviewUseCase = makeFetchReviewUseCase()
        
        return CustomerReviewListViewModel(
            fetchReviewUseCase: fetchReviewUseCase,
            creatorUser: creatorUser,
            reservationCoordinator: reservationCoordinator
        )
    }
    
    private func makeFetchReviewUseCase() -> FetchReviewUseCase {
        let reviewRepository = makeReviewRepository()
        let photographerRepository = makePhotographerRepository()
        
        return DefaultFetchReviewUseCase(
            reviewRepository: reviewRepository,
            userRepository: userRepository,
            photographerRepository: photographerRepository
        )
    }
    
    private func makePhotographerRepository() -> PhotographerRepository {
        return DefaultPhotographerRepository(firestoreService: firestoreService)
    }
}

// MARK: - Reservation Status Factory
extension ReservationDependencyContainer: ReservationStatusFactory {
    
    func makeReservationRequested(reservation: Reservation, userType: Reservation.UserType) -> ReservationRequested {
        return ReservationRequested(
            reservation: reservation,
            userType: userType,
            acceptReservationRequestUseCaseFactory: makeAcceptReservationRequestUseCase,
            cancelReservationRequestUseCaseFactory: makeCancelReservationRequestUseCase
        )
    }
    
    func makeReservationConfirmed(reservation: Reservation, userType: Reservation.UserType) -> ReservationConfirmed {
        return ReservationConfirmed(
            reservation: reservation,
            userType: userType,
            completePhotoshootUseCaseFactory: makeCompletePhotoshootUseCase,
            cancelReservationRequestUseCaseFactory: makeCancelReservationRequestUseCase
        )
    }
    
    func makeReservationCancelled(reservation: Reservation, userType: Reservation.UserType) -> ReservationCancelled {
        return ReservationCancelled(
            reservation: reservation,
            userType: userType,
            navigateToReservationDetail: { Logger.print($0) }
        )
    }
    
    func makeReservationDone(reservation: Reservation, userType: Reservation.UserType) -> ReservationDone {
        return ReservationDone(
            reservation: reservation,
            userType: userType,
            navigateToWriteReview: reservationCoordinator?.showCreateReviewViewController
        )
    }
    
    private func makeAcceptReservationRequestUseCase() -> AcceptReservationRequestUseCase {
        return DefaultAcceptReservationRequestUseCase(repository: reservationRepository)
    }
    
    private func makeCancelReservationRequestUseCase() -> CancelReservationRequestUseCase {
        return DefaultCancelReservationRequestUseCase(repository: reservationRepository)
    }
    
    private func makeCompletePhotoshootUseCase() -> CompletePhotoshootUseCase {
        return DefaultCompletePhotoshootUseCase(repository: reservationRepository)
    }
}

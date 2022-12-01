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
            reservationId: reservationId
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
}

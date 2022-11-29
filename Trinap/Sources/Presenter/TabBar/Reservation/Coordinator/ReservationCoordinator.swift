//
//  ReservationCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import FirestoreService

final class ReservationCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let firestoreService: FireStoreService
    
    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        self.firestoreService = DefaultFireStoreService()
    }
    
    // MARK: - Methods
    func start() {
        self.showReservationListViewController()
    }
}

extension ReservationCoordinator {
    
    func showReservationListViewController() {
        let viewModel = ReservationPreviewListViewModel(
            coordinator: self,
            fetchReservationPreviewsUseCase: makeFetchReservationPreviewsUseCase()
        )
        let viewController = ReservationPreviewListViewController(viewModel: viewModel)
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeFetchReservationPreviewsUseCase() -> FetchReservationPreviewsUseCase {
        let reservationRepository = DefaultReservationRepository(firebaseStoreService: firestoreService)
        let userRepository = DefaultUserRepository()
        let mapRepository = DefaultMapRepository()
        
        return DefaultFetchReservationPreviewsUseCase(
            reservationRepository: reservationRepository,
            userRepository: userRepository,
            mapRepository: mapRepository
        )
    }
}

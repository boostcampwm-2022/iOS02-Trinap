//
//  ReservationCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class ReservationCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private lazy var dependencies = ReservationDependencyContainer(reservationCoordinator: self)
    
    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Methods
    func start() {
        self.showReservationPreviewListViewController()
    }
}

extension ReservationCoordinator {
    
    func showReservationPreviewListViewController() {
        let reservationPreviewListViewController = dependencies.makeReservationPreviewListViewController()
        
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.pushViewController(reservationPreviewListViewController, animated: true)
    }
    
    func showReservationDetailViewController(reservationId: String) {
        let reservationDetailViewController = dependencies.makeReservationDetailViewController(
            reservationId: reservationId
        )
        
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(reservationDetailViewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
    }
    
    func showCreateReviewViewController(reservation: Reservation) {
        let photographerUserId = reservation.photographerUser.userId
        let createReviewViewController = dependencies.makeCreateReviewViewController(
            photographerUserId: photographerUserId
        )
        
        self.navigationController.present(createReviewViewController, animated: true)
    }
}

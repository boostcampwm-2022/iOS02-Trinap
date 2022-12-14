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
        
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
        self.navigationController.pushViewController(reservationPreviewListViewController, animated: true)
    }
    
    func showReservationDetailViewController(reservationId: String) {
        let reservationDetailViewController = dependencies.makeReservationDetailViewController(
            reservationId: reservationId
        )
        
        reservationDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(reservationDetailViewController, animated: true)
    }
    
    func showCreateReviewViewController(reservation: Reservation) {
        let photographerUserId = reservation.photographerUser.userId
        let createReviewViewController = dependencies.makeCreateReviewViewController(
            photographerUserId: photographerUserId
        )
        
        self.navigationController.present(createReviewViewController, animated: true)
    }
    
    func showCustomerReviewListViewController(customerUser: User) {
        let customerReviewListViewController = dependencies.makeCustomerReviewListViewController(
            creatorUser: customerUser
        )
        
        customerReviewListViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(customerReviewListViewController, animated: true)
    }
}

extension ReservationCoordinator {
    
    func connectDetailPhotographerFlow(userId: String, searchCoordinate: Coordinate) {
        let photographerDetailCoordinator = PhotographerDetailCoordinator(
            userId: userId,
            searchCoordinate: searchCoordinate,
            navigationController: self.navigationController
        )
        photographerDetailCoordinator.delegate = self
        photographerDetailCoordinator.start()
        self.childCoordinators.append(photographerDetailCoordinator)
    }
}

// MARK: - Coodinator Delegate
extension ReservationCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        if childCoordinator is PhotographerDetailCoordinator {
            self.navigationController.popViewController(animated: false)
        }
    }
}

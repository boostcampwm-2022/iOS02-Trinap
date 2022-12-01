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
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(reservationPreviewListViewController, animated: true)
    }
}

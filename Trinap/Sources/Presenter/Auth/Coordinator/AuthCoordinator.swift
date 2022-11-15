//
//  AuthCoordinator.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: - Methods
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showSignInViewController()
    }
}

private extension AuthCoordinator {
    func showSignInViewController() {
        let viewController = SignInViewController()
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.navigationController.pushViewController(viewController, animated: false)
    }
}

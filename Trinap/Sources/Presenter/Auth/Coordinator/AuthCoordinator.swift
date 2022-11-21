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
    
    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showSignInViewController()
    }
}

// MARK: - Private Methods
extension AuthCoordinator {
    func showSignInViewController() {
        let viewController = SignInViewController(
            viewModel: SignInViewModel(
                signInUseCase: DefaultSignInUseCase(
                    authRepository: DefaultAuthRepository()
                ),
                coordinator: self
            )
        )
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    // TODO: CreateUserViewController로 이동하는 Method 구현
    func showCreateUserViewController() {
        let viewController = CreateUserViewController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: false)
    }
}

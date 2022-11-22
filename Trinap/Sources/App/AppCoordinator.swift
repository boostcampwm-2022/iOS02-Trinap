//
//  AppCoordinator.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Methods
    func start() {
        showSplashViewController()
    }
}

// MARK: - connectFlow Methods
extension AppCoordinator {
    
    func showSplashViewController() {
        let splashViewController = SplashViewController(
            viewModel: SplashViewModel(
                signInUseCase: DefaultSignInUseCase(
                    authRepository: DefaultAuthRepository()
                ),
                coordinator: self
            )
        )
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(splashViewController, animated: false)
    }
    
    func connectAuthFlow() {
        self.navigationController.viewControllers.removeAll()
        let authCoordinator = AuthCoordinator(self.navigationController)
        authCoordinator.delegate = self
        authCoordinator.start()
        self.childCoordinators.append(authCoordinator)
    }
    
    func connectTabBarFlow() {
        self.navigationController.viewControllers.removeAll()
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        self.childCoordinators.append(tabBarCoordinator)
    }
}

// MARK: - Coodinator Delegate
extension AppCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: true)
        if childCoordinator is AuthCoordinator {
            self.connectTabBarFlow()
        } else {
            self.connectAuthFlow()
        }
    }
}

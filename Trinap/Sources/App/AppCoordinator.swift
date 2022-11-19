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
    
    // MARK: - Methods
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let splashViewController = SplashViewController()
        
        navigationController.pushViewController(splashViewController, animated: false)
    }
}

// MARK: - Private Methods
private extension AppCoordinator {
    
    func connectAuthFlow() {
        let authCoordinator = AuthCoordinator(self.navigationController)
        authCoordinator.delegate = self
        authCoordinator.start()
        self.childCoordinators.append(authCoordinator)
    }
    
    func connectTaBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        self.childCoordinators.append(tabBarCoordinator)
    }
}

// MARK: - Coodinator Delegate
extension AppCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        // TODO: AuthFlow <-> TabBarFlow로 전환 구현
        navigationController.viewControllers.removeAll()
        if childCoordinator is AuthCoordinator {
            self.connectTaBarFlow()
        } else {
            self.connectAuthFlow()
        }
        Logger.print("끝")
    }
}

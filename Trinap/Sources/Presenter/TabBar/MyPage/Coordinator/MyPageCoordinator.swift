//
//  MyPageCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    
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
        self.showMyPageViewController()
    }
}

extension MyPageCoordinator {
    func showMyPageViewController() {
        let viewModel = MyPageViewModel(fetchUserUseCase: DefaultFetchUserUseCase(userRepository: DefaultUserRepository()))
        let viewController = MyPageViewController(viewModel: viewModel)
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

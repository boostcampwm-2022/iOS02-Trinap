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
                    authRepository: makeAuthRepository()
                ),
                coordinator: self
            )
        )
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func showCreateUserViewController() {
        let viewController = CreateUserViewController(
            viewModel: CreateUserViewModel(
                createUserUseCase: DefaultCreateUserUseCase(
                    authRepository: makeAuthRepository(),
                    userRepository: makeUserRepository(),
                    photographerRepository: makePhotographerRepository()
                ),
                coordinator: self
            )
        )
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeAuthRepository() -> AuthRepository {
        #if DEBUG
        if FakeRepositoryEnvironment.useFakeRepository {
            return FakeAuthRepository()
        }
        #endif
        return DefaultAuthRepository()
    }
    
    private func makeUserRepository() -> UserRepository {
        #if DEBUG
        if FakeRepositoryEnvironment.useFakeRepository {
            return FakeUserRepository()
        }
        #endif
        return DefaultUserRepository()
    }
    
    private func makePhotographerRepository() -> PhotographerRepository {
        #if DEBUG
        if FakeRepositoryEnvironment.useFakeRepository {
            return FakePhotographerRepository()
        }
        #endif
        return DefaultPhotographerRepository()
    }
}

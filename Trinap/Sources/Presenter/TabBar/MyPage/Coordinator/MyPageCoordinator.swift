//
//  MyPageCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import FirestoreService

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
        let useCase = DefaultFetchUserUseCase(
            userRepository: DefaultUserRepository(firestoreService: DefaultFireStoreService())
        )
        let viewModel = MyPageViewModel(fetchUserUseCase: useCase)
        let viewController = MyPageViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showNextView(state: MyPageCellType) {
        switch state {
        case .nofiticationAuthorization, .photoAuthorization, .locationAuthorization:
            showAuthorizationSetting(state: state)
        case .profile(user: let user):
            showEditViewController(user: user)
        default:
            return
        }
    }
    
    func showEditViewController(user: User) {
        let useCase = DefaultEditUserUseCase(userRepository: DefaultUserRepository())
        let viewModel = EditProfileViewModel(
            user: user,
            editUserUseCase: useCase,
            uploadImageUseCase: DefaultUploadImageUseCase(uploadImageRepository: DefaultUploadImageRepository())
        )
        let viewController = EditProfileViewController(viewModel: viewModel)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

private extension MyPageCoordinator {
    private func showAuthorizationSetting(state: MyPageCellType) {
        guard let url = state.url else { return }
        UIApplication.shared.open(url)
    }
}

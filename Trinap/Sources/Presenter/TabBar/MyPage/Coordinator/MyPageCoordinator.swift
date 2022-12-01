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
        case .phohographerProfile:
            showEditPhotographerProfile()
        case .nofiticationAuthorization, .photoAuthorization, .locationAuthorization:
            showAuthorizationSetting(state: state)
        case .profile(user: let user):
            showEditViewController(user: user)
        case .photographerDate:
            showEditPossibleDateViewController()
        default:
            return
        }
    }
    
    private func showEditViewController(user: User) {
        let viewModel = EditProfileViewModel(
            fetchUserUseCase: DefaultFetchUserUseCase(userRepository: DefaultUserRepository()),
            editUserUseCase: DefaultEditUserUseCase(userRepository: DefaultUserRepository()),
            uploadImageUseCase: DefaultUploadImageUseCase(uploadImageRepository: DefaultUploadImageRepository())
        )
        let viewController = EditProfileViewController(viewModel: viewModel)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showEditPhotographerProfile() {
        let viewModel = EditPhotographerViewModel(
            fetchUserUseCase: DefaultFetchUserUseCase(userRepository: DefaultUserRepository()),
            fetchPhotographerUseCase: DefaultFetchPhotographerUseCase(photographerRespository: DefaultPhotographerRepository()),
            fetchReviewUseCase: DefaultFetchReviewUseCase(
                reviewRepositry: DefaultReviewRepository(),
                userRepository: DefaultUserRepository(),
                photographerRepository: DefaultPhotographerRepository()
            ),
            editPortfolioPictureUseCase: DefaultEditPortfolioPictureUseCase(photographerRepository: DefaultPhotographerRepository()),
            mapRepository: DefaultMapRepository()
        )
        let viewController = EditPhotographerViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showUpdatePhotographerViewController() {
        let viewController = UpdateDetailPhotographerViewController(viewModel: UpdateDetailPhotographerViewModel())
        navigationController.present(viewController, animated: true)
    }

    private func showEditPossibleDateViewController() {
        let photographerRepository = DefaultPhotographerRepository()
        let viewModel = EditPossibleDateViewModel(
            editPhotographerUseCase: DefaultEditPhotographerUseCase(
                photographerRepository: photographerRepository
            ),
            fetchPhotographerUseCase: DefaultFetchPhotographerUseCase(
                photographerRespository: photographerRepository
            ),
            coordinator: self
        )
        
        let viewController = EditPossibleDateViewController(viewModel: viewModel)
        
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
    }
}

private extension MyPageCoordinator {
    private func showAuthorizationSetting(state: MyPageCellType) {
        guard let url = state.url else { return }
        UIApplication.shared.open(url)
    }
}

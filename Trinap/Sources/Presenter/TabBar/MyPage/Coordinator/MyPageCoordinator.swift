//
//  MyPageCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

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
            userRepository: DefaultUserRepository()
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
        case .dropout:
            showDropOutViewController()
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
        let viewModel = RegisterPhotographerInfoViewModel(
            coordinator: self,
            fetchPhotographerUseCase: DefaultFetchPhotographerUseCase(photographerRespository: DefaultPhotographerRepository()),
            editPhotographerUseCase: DefaultEditPhotographerUseCase(photographerRepository: DefaultPhotographerRepository()),
            mapRepository: DefaultMapRepository()
        )

        let viewController = RegisterPhotographerInfoViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchViewController(
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) {
        let viewModel = SearchViewModel(
            searchLocationUseCase: DefaultSearchLocationUseCase(
                mapService: DefaultMapRepository()
            ),
            fetchCurrentLocationUseCase: DefaultFetchCurrentLocationUseCase(
                mapRepository: DefaultMapRepository()
            ),
            coordinator: self,
            searchText: searchText,
            coordinate: coordinate
        )
        let viewController = SearchViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
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
    
    func showDropOutViewController() {
        let viewModel = DropOutViewModel(
            coordinator: self,
            dropOutUseCase: DefaultDropOutUseCase(
                authRepository: DefaultAuthRepository(),
                photographerRepository: DefaultPhotographerRepository()
            )
        )
        
        let viewController = DropOutViewController(viewModel: viewModel)
        
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
}

extension MyPageCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) { }
}

private extension MyPageCoordinator {
    private func showAuthorizationSetting(state: MyPageCellType) {
        guard let url = state.url else { return }
        UIApplication.shared.open(url)
    }
}

//
//  MainCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxRelay

final class MainCoordinator: Coordinator {
    
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
        self.showPhotographerListViewController()
    }
}

extension MainCoordinator {
    
    func showPhotographerListViewController() {
        let viewController = PhotographerListViewController(
            viewModel: PhotographerListViewModel(
                previewsUseCase: DefaultFetchPhotographerPreviewsUseCase(
                    photographerRepository: DefaultPhotographerRepository(),
                    mapRepository: DefaultMapRepository(),
                    userRepository: DefaultUserRepository(),
                    reviewRepository: DefaultReviewRepository()),
                coordinator: self
            ))
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchViewController(searchText: BehaviorRelay<String>) {
        let viewModel = SearchViewModel(
            searchLocationUseCase: DefaultSearchLocationUseCase(
                mapService: DefaultMapRepository()
            ),
            coordinator: self
        )
        let viewController = SearchViewController(
            viewModel: viewModel,
            searchText: searchText
        )
        
        self.navigationController.setNavigationBarHidden(false, animated: false)
//        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: false)
//        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false

    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
}

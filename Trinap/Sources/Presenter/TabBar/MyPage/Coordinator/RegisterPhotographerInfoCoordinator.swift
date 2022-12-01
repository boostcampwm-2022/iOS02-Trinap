//
//  RegisterPhotographerInfoCoordinator.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class RegisterPhotographerInfoCoordinator: Coordinator {
    
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
        self.showUpdatePhotographerViewController()
    }
}

extension RegisterPhotographerInfoCoordinator {
    func showUpdatePhotographerViewController() {
        let viewModel = RegisterPhotographerInfoViewModel(
            coordinator: self,
            fetchPhotographerUseCase: DefaultFetchPhotographerUseCase(photographerRespository: DefaultPhotographerRepository()),
            editPhotographerUseCase: DefaultEditPhotographerUseCase(photographerRepository: DefaultPhotographerRepository()),
            mapRepository: DefaultMapRepository()
        )

        let viewController = UINavigationController(rootViewController: RegisterPhotographerInfoViewController(viewModel: viewModel))
        navigationController.present(viewController, animated: true)
    }
//
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
        let viewController = SearchViewController(
            viewModel: viewModel
        )
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

//
//  MainCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxRelay
import FirestoreService

final class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private lazy var dependencies = MainDependencyContainer(mainCoordinator: self)
    
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
        let viewController = dependencies.makePhotographerListViewController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    // TODO: - ViewModel Delegate Setting
    func showSelectReservationDateViewController(with possibleDate: [Date], detailViewModel: PhotographerDetailViewModel) {
        let viewModel = SelectReservationDateViewModel(
            createReservationDateUseCase: DefaultCreateReservationDateUseCase(),
            coordinator: self,
            with: possibleDate
        )
        
        viewModel.delegate = detailViewModel
        
        let viewController = SelectReservationDateViewController(
            viewModel: viewModel
        )
                
        self.navigationController.present(viewController, animated: true)
    }
    
    func showSearchViewController(
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) {
        let viewModel = SearchViewModel(
            searchLocationUseCase: DefaultSearchLocationUseCase(
                mapService: dependencies.mapRepository
            ),
            fetchCurrentLocationUseCase: DefaultFetchCurrentLocationUseCase(
                mapRepository: dependencies.mapRepository
            ),
            coordinator: self,
            searchText: searchText,
            coordinate: coordinate
        )
        let viewController = SearchViewController(
            viewModel: viewModel
        )
        
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false

    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        
    }
    
    func showDetailPhotographerViewController(userId: String, searchCoordinate: Coordinate) {

        let viewController = dependencies.makePhotographerDetailViewController(
            userId: userId,
            searchCoordinate: searchCoordinate
        )

        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
    }
}

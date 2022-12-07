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
    
    func connectDetailPhotographerFlow(userId: String, searchCoordinate: Coordinate) {
        let photographerDetailCoordinator = PhotographerDetailCoordinator(
            userId: userId,
            searchCoordinate: searchCoordinate,
            navigationController: self.navigationController
        )
        photographerDetailCoordinator.delegate = self
        photographerDetailCoordinator.start()
        self.childCoordinators.append(photographerDetailCoordinator)
    }
}

// MARK: - Coodinator Delegate
extension MainCoordinator: CoordinatorDelegate {
    
    //TODO: 프록시로 하고싶은데....
    func didFinish(childCoordinator: Coordinator) {
        // PhotographerDetailCoordinator 끝났을 때
        // 근데 네비바에서 뒤로 가기 하면 이거 해줄 필요가 있을까?????????
        if childCoordinator is PhotographerDetailCoordinator {
            self.navigationController.popViewController(animated: false)
        }
    }
}

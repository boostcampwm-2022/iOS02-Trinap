//
//  MainCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

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
        // TODO: 추후 UI를 구현한 ViewController로 교체
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    // TODO: - ViewModel Delegate Setting
    func showSelectReservationDateViewController(with possibleDate: [Date]) {
        let viewModel = SelectReservationDateViewModel(
            createReservationDateUseCase: DefaultCreateReservationDateUseCase(),
            coordinator: self,
            with: possibleDate
        )
        
        let viewController = SelectReservationDateViewController(
            viewModel: viewModel
        )
                
        self.navigationController.present(viewController, animated: true)
    }
}

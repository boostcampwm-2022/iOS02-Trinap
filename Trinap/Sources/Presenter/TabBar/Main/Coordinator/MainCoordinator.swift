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
    private var selectReservationDateViewController: SelectReservationDateViewController?
    
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
        let viewController = MockPhotographerListViewController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSelectReservationDateViewController(with photographerId: String) {
        let viewModeel = SelectReservationDateViewModel(
            createReservationDateUseCase: DefaultCreateReservationDateUseCase(),
            coordinator: self
        )
        
        self.selectReservationDateViewController = SelectReservationDateViewController(
            viewModel: viewModeel
        )
        
        guard let viewController = self.selectReservationDateViewController else { return }
        
        self.navigationController.present(viewController, animated: true)
    }
    
    func dismissSelectReservationDateViewController() {
        self.selectReservationDateViewController?.dismiss(animated: true)
    }
}

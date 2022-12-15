//
//  Coordinator.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    
    func didFinish(childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    init(_ navigationController: UINavigationController)

    func start()
    func finish()
    func popViewController()
    func dismissViewController()
    func presentErrorAlert(title: String?, message: String?, handler: (() -> Void)?)
}

extension Coordinator {
    
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }
    
    func presentErrorAlert(
        title: String? = nil,
        message: String? = .errorDetected,
        handler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            .appendingAction(title: "확인", handler: handler)
        
        navigationController.present(alertController, animated: true)
    }
}

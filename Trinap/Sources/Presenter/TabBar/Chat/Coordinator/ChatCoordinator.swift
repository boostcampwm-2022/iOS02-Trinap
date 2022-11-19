//
//  ChatCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import FirestoreService

final class ChatCoordinator: Coordinator {
    
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
        self.showChatPreviewsViewController()
    }
}

extension ChatCoordinator {
    func showChatPreviewsViewController() {
        // TODO: 추후 UI를 구현한 ViewController로 교체
        let viewController = MockChatViewController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

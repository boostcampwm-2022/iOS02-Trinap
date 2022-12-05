//
//  TabBarCoordinator.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator]
    
    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
    }
    
    // MARK: - Methods
    func start() {
        let pages: [TabBarPageType] = TabBarPageType.allCases
        let controllers: [UINavigationController] = pages.map {
            self.createTabNavigationController(of: $0)
        }
        self.configureTabBarController(with: controllers)
    }
    
    func currentPage() -> TabBarPageType? {
        return TabBarPageType(rawValue: self.tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPageType) {
        self.tabBarController.selectedIndex = page.rawValue
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPageType(rawValue: index) else { return }
        self.tabBarController.selectedIndex = page.rawValue
    }
}

private extension TabBarCoordinator {
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPageType.main.rawValue
        self.tabBarController.view.backgroundColor = TrinapAsset.background.color
        self.tabBarController.tabBar.backgroundColor = TrinapAsset.background.color
        self.tabBarController.tabBar.tintColor = TrinapAsset.primary.color
        self.tabBarController.tabBar.unselectedItemTintColor = TrinapAsset.gray40.color
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func createTabNavigationController(of page: TabBarPageType) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = page.tabBarItem
        connectTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    func connectTabCoordinator(of page: TabBarPageType, to tabNavigationController: UINavigationController) {
        switch page {
        case .main:
            self.connectMainFlow(to: tabNavigationController)
        case .chat:
            self.connectChatFlow(to: tabNavigationController)
        case .reservation:
            self.connectReservationFlow(to: tabNavigationController)
        case .myPage:
            self.connectMyPageFlow(to: tabNavigationController)
        }
    }
    
    func connectMainFlow(to tabNavigationController: UINavigationController) {
        let mainCoordinator = MainCoordinator(tabNavigationController)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
    
    func connectChatFlow(to tabNavigationController: UINavigationController) {
        let chatCoordinator = ChatCoordinator(tabNavigationController)
        chatCoordinator.start()
        childCoordinators.append(chatCoordinator)
    }
    
    func connectReservationFlow(to tabNavigationController: UINavigationController) {
        let reservationCoordinator = ReservationCoordinator(tabNavigationController)
        reservationCoordinator.start()
        childCoordinators.append(reservationCoordinator)
    }
    
    func connectMyPageFlow(to tabNavigationController: UINavigationController) {
        let myPageCoordinator = MyPageCoordinator(tabNavigationController)
        myPageCoordinator.delegate = self
        myPageCoordinator.start()
        childCoordinators.append(myPageCoordinator)
    }
}

extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: false)
        self.finish()
    }
}

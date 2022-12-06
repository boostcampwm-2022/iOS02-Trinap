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
    
    private lazy var dependencies = MyPageDependencyContainter(mypageCoordinator: self)
    
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
        let viewController = dependencies.makeMyPageViewController()
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showNextView(state: MyPageCellType) {
        switch state {
        case .phohographerProfile:
            showEditPhotographerProfile()
        case .nofiticationAuthorization, .photoAuthorization, .locationAuthorization:
            showAuthorizationSetting(state: state)
        case .profile:
            showEditProfileViewController()
        case.contact:
            showContactListViewController()
        case .photographerDate:
            showEditPossibleDateViewController()
        case .dropout:
            showDropOutViewController()
        default:
            return
        }
    }
    
    private func showEditProfileViewController() {
        let viewController = dependencies.makeEditProfileViewController()
        self.navigationController.pushViewControllerHideBottomBar(rootViewController: viewController, animated: true)
    }
    
    private func showEditPhotographerProfile() {
        let viewController = dependencies.makeEditPhotographerViewController()
        viewController.coordinator = self
        self.navigationController.pushViewControllerHideBottomBar(rootViewController: viewController, animated: true)
    }
    
    func showUpdatePhotographerViewController() {
        let viewController = dependencies.makeRegisterPhotographerInfoViewController()
        self.navigationController.pushViewControllerHideBottomBar(rootViewController: viewController, animated: true)
    }
    
    func showSearchViewController(
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) {
        let viewController = dependencies.makeSearchViewController(searchText: searchText, coordinate: coordinate)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func showDetailImageView(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else {
            return
        }
        
        let viewController = DetailImageViewController()
        viewController.configureImageView(url: url)
        viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(viewController, animated: false)
    }
    
    private func showEditPossibleDateViewController() {
        let viewController = dependencies.makeEditPossibleDateViewController()
        self.navigationController.pushViewControllerHideBottomBar(rootViewController: viewController, animated: true)
    }
    
    func showDropOutViewController() {
        let viewController = dependencies.makeDropOutViewController()
        self.navigationController.pushViewControllerHideBottomBar(rootViewController: viewController, animated: true)
    }
    
    func showSignOutAlert(completion: @escaping () -> Void) {
        let alert = TrinapAlert(
            title: "로그아웃",
            timeText: nil,
            subtitle: "정말 로그아웃 하시겠어요?"
        )
        alert.addAction(
            title: "취소",
            style: .disabled,
            completion: { }
        )
        alert.addAction(
            title: "로그아웃",
            style: .primary,
            completion: completion
        )
        alert.showAlert(navigationController: self.navigationController)
    }
    
    func showContactListViewController() {
        let viewController = dependencies.makeContactListViewController()
        self.navigationController.pushViewControllerHideBottomBar(rootViewController: viewController, animated: false)
    }
    
    func showDetailContactViewController(contactId: String) {
        let viewController = dependencies.makeDetailContactViewController(contactId: contactId)
        self.navigationController.pushViewControllerHideBottomBar(rootViewController: viewController, animated: false)
    }
    
    func showCreateContactViewController() {
        let viewController = dependencies.makeCreateContactViewController()
        self.navigationController.present(viewController, animated: true)
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

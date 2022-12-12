//
//  PhotographerDetailCoordinator.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/08.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class PhotographerDetailCoordinator: Coordinator {
    
    // MARK: Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private lazy var dependencies = PhotographerDetailDependencyContainer(photographerDetailCoordinator: self)
    
    private var searchCoordinate: Coordinate?
    private var userId: String?
    
    // MARK: Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    convenience init(
        userId: String,
        searchCoordinate: Coordinate,
        navigationController: UINavigationController
    ) {
        self.init(navigationController)
        self.userId = userId
        self.searchCoordinate = searchCoordinate
    }

    // MARK: Methods
    func start() {
        guard
            let userId,
            let searchCoordinate
        else { return }
        
        self.showDetailPhotographerViewController(userId: userId, searchCoordinate: searchCoordinate)
    }
    
    func showDetailPhotographerViewController(userId: String, searchCoordinate: Coordinate) {

        let viewController = dependencies.makePhotographerDetailViewController(
            userId: userId,
            searchCoordinate: searchCoordinate
        )

        self.navigationController.isNavigationBarHidden = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
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
    
    func showDetailImageView(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        let viewController = DetailImageViewController()
        viewController.configureImageView(url: url)
        viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(viewController, animated: false)
    }
    
    func showSueController(suedUserId: String) {
        let viewController = dependencies.makeSueViewController(userId: suedUserId)
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func connectChatDetailCoordinator(chatroomId: String, photographerNickname: String) {
        let chatDetailCoordinator = ChatDetailCoordinator(
            self.navigationController,
            chatroomId: chatroomId,
            nickname: photographerNickname
        )
        chatDetailCoordinator.start()
        self.childCoordinators.append(chatDetailCoordinator)
    }
}

// MARK: - Chat Detail
extension PhotographerDetailCoordinator {
    
    func connectChatDetailCoordinator(chatroomId: String, nickname: String) {
        let chatDetailCoordinator = ChatDetailCoordinator(
            self.navigationController,
            chatroomId: chatroomId,
            nickname: nickname
        )
        
        self.childCoordinators.append(chatDetailCoordinator)
        
        chatDetailCoordinator.start()
    }
}

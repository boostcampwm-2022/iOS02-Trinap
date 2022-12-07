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
    
    private let chatRepository: ChatRepository
    private let observeChatPreviewsUseCase: ObserveChatPreviewsUseCase
    private let observeChatUseCase: ObserveChatUseCase
    
    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let firestoreService = DefaultFireStoreService()
        let userRepository = DefaultUserRepository(firestoreService: firestoreService)
        let chatroomRepository = DefaultChatroomRepository(firebaseStoreService: firestoreService)
        
        self.chatRepository = DefaultChatRepository(firestoreService: firestoreService)
        
        self.observeChatPreviewsUseCase = DefaultObserveChatPreviewsUseCase(
            chatroomRepository: chatroomRepository,
            userRepository: userRepository
        )
        
        self.observeChatUseCase = DefaultObserveChatUseCase(
            chatRepository: chatRepository,
            userRepository: userRepository
        )
    }
    
    // MARK: - Methods
    func start() {
        self.showChatPreviewsViewController()
    }
}

extension ChatCoordinator {
    
    func showChatPreviewsViewController() {
        let chatPreviewsViewModel = ChatPreviewsViewModel(
            coordinator: self,
            observeChatPreviewsUseCase: observeChatPreviewsUseCase,
            observeChatUseCase: observeChatUseCase
        )
        let viewController = ChatPreviewsViewController(viewModel: chatPreviewsViewModel)
        
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showChatDetailViewController(chatroomId: String, nickname: String) {
        let uploadImageRepository = DefaultUploadImageRepository()
        
        let sendChatUseCase = DefaultSendChatUseCase(chatRepository: chatRepository)
        let uploadImageUseCase = DefaultUploadImageUseCase(uploadImageRepository: uploadImageRepository)
        let updateIsCheckedUseCase = DefaultUpdateIsCheckedUseCase(chatRepository: chatRepository)
        
        let chatDetailViewModel = ChatDetailViewModel(
            coordinator: self,
            chatroomId: chatroomId,
            nickname: nickname,
            observeChatUseCase: observeChatUseCase,
            sendChatUseCase: sendChatUseCase,
            uploadImageUseCase: uploadImageUseCase,
            updateIsCheckedUseCase: updateIsCheckedUseCase
        )
        let viewController = ChatDetailViewController(viewModel: chatDetailViewModel)
        
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
    }
    
    func showLocationShareViewController(chatroomId: String) {
        let locationRepository = DefaultLocationRepository()
        let observeLocationUseCase = DefaultObserveLocationUseCase(locationRepository: locationRepository)
        let updateLocationUseCase = DefaultUpdateLocationUseCase(locationRepository: locationRepository)
        let endLocationShareUseCase = DefaultEndLocationShareUseCase(locationRepository: locationRepository)
        let locationShareViewModel = LocationShareViewModel(
            chatroomId: chatroomId,
            observeLocationUseCase: observeLocationUseCase,
            updateLocationUseCase: updateLocationUseCase,
            endLocationShareUseCase: endLocationShareUseCase
        )
        let locationShareViewController = LocationShareViewController(viewModel: locationShareViewModel)

        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(locationShareViewController, animated: true)
    }
}

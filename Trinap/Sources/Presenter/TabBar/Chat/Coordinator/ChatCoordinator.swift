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
        
        #if DEBUG
        if FakeRepositoryEnvironment.useFakeRepository {
            let userRepository = FakeUserRepository()
            let chatroomRepository = FakeChatroomRepository()
            self.chatRepository = FakeChatRepository()
            
            self.observeChatPreviewsUseCase = DefaultObserveChatPreviewsUseCase(
                chatroomRepository: chatroomRepository,
                userRepository: userRepository
            )
            
            self.observeChatUseCase = DefaultObserveChatUseCase(
                chatRepository: chatRepository,
                userRepository: userRepository
            )
            
            return
        }
        #endif
        
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
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showChatDetailViewController(chatroomId: String, nickname: String) {
        let chatDetailCoordinator = ChatDetailCoordinator(
            self.navigationController,
            chatroomId: chatroomId,
            nickname: nickname
        )
        
        self.childCoordinators.append(chatDetailCoordinator)
        
        chatDetailCoordinator.start()
    }
}

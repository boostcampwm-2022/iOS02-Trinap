//
//  ChatDetailCoordinator.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/08.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import FirestoreService

final class ChatDetailCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let chatroomId: String
    private let nickname: String
    
    private let chatRepository: ChatRepository
    private let observeChatPreviewsUseCase: ObserveChatPreviewsUseCase
    private let observeChatUseCase: ObserveChatUseCase
    
    // MARK: - Initializers
    init(
        _ navigationController: UINavigationController,
        chatroomId: String,
        nickname: String
    ) {
        self.navigationController = navigationController
        self.chatroomId = chatroomId
        self.nickname = nickname
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
    
    init(_ navigationController: UINavigationController) {
        fatalError("\(Self.self) should initialized with chatroomId and nickname.")
    }
    
    // MARK: - Methods
    func start() {
        self.showChatDetailViewController(chatroomId: chatroomId, nickname: nickname)
    }
}

extension ChatDetailCoordinator {
    
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
        
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
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

        locationShareViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(locationShareViewController, animated: true)
    }
}


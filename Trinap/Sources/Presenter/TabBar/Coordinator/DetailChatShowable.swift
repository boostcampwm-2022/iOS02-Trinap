////
////  DetailChatShowable.swift
////  Trinap
////
////  Created by kimchansoo on 2022/12/06.
////  Copyright © 2022 Trinap. All rights reserved.
////
//
//import UIKit
//
//import FirestoreService
//
//protocol DetailChatShowable {
//    
//}
//
//extension DetailChatShowable {
//    func showChatDetailViewController(chatroomId: String) {
//        guard let self = self as? Coordinator else { return }
//        
//        let chatRepository = DefaultChatRepository(
//            firestoreService: DefaultFireStoreService()
//        )
//        let userRepository = DefaultUserRepository()
//        
//        let uploadImageRepository = DefaultUploadImageRepository()
//        
//        let sendChatUseCase = DefaultSendChatUseCase(
//            chatRepository: chatRepository)
//        let uploadImageUseCase = DefaultUploadImageUseCase(uploadImageRepository: uploadImageRepository)
//        let updateIsCheckedUseCase = DefaultUpdateIsCheckedUseCase(chatRepository: chatRepository)
//        
//        //MARK: 여기서 coordinator 타입이 initalizer에서 chatCoordinator라서... 우짤까요?
//        let chatDetailViewModel = ChatDetailViewModel(
//            coordinator: self,
//            chatroomId: chatroomId,
//            observeChatUseCase: DefaultObserveChatUseCase(
//                chatRepository: chatRepository,
//                userRepository: userRepository
//            ),
//            sendChatUseCase: sendChatUseCase,
//            uploadImageUseCase: uploadImageUseCase,
//            updateIsCheckedUseCase: updateIsCheckedUseCase
//        )
//        let viewController = ChatDetailViewController(viewModel: chatDetailViewModel)
//        
//        self.navigationController.setNavigationBarHidden(false, animated: false)
//        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
//        self.navigationController.pushViewController(viewController, animated: true)
//        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
//    }
//}

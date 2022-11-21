//
//  DefaultChatRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultChatRepository: ChatRepository {
    
    // MARK: - Properties
    private let firestoreService: FireStoreService
    private let tokenManager: TokenManager
    
    // MARK: - Methods
    init(
        firestoreService: FireStoreService,
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.firestoreService = firestoreService
        self.tokenManager = tokenManager
    }
    
    func observe(chatroomId: String) -> Observable<[Chat]> {
        guard let userId = tokenManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firestoreService
            .observe(documents: ["chatrooms", chatroomId, "chats"])
            .map { $0.compactMap { $0.toObject(ChatDTO.self)?.toModel(clientId: userId) } }
            .map { $0.sorted { $0.createdAt < $1.createdAt } }
            .asObservable()
    }
    
    func send(chatType: Chat.ChatType, content: String, at chatroomId: String) -> Observable<Void> {
        guard let userId = tokenManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        let chatDTO = ChatDTO(
            chatId: UUID().uuidString,
            senderUserId: userId,
            chatType: chatType,
            content: content,
            isChecked: false,
            createdAt: Date().toString(type: .timeStamp)
        )
        
        guard let values = chatDTO.asDictionary else {
            return .error(FireStoreError.unknown)
        }
        
        return self.firestoreService
            .createDocument(documents: ["chatrooms", chatroomId, "chats", chatDTO.chatId], values: values)
            .asObservable()
    }
}

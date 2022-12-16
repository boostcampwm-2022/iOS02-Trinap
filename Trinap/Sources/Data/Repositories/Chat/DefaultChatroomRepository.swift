//
//  DefaultChatroomRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultChatroomRepository: ChatroomRepository {

    // MARK: - Properties
    private let firebaseStoreService: FireStoreService
    private let tokenManager: TokenManager

    // MARK: - Methods
    init(
        firebaseStoreService: FireStoreService,
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.firebaseStoreService = firebaseStoreService
        self.tokenManager = tokenManager
    }

    func observe() -> Observable<[Chatroom]> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return observeChatrooms(userId: userId, forType: "customerUserId")
            .flatMap { [weak self] customerChatroomsDTO -> Observable<[ChatroomDTO]> in
                guard let self else { return .error(FireStoreError.unknown) }
                
                return self.observeChatrooms(userId: userId, forType: "photographerUserId")
                    .map { $0 + customerChatroomsDTO }
            }
            .map { $0.map { $0.toModel() } }
    }
    
    func fetchChatrooms() -> Observable<[Chatroom]> {
        fetchChatrooms(field: "photographerUserId")
            .withUnretained(self)
            .flatMap { owner, chatrooms -> Observable<[Chatroom]> in
                return owner.fetchChatrooms(field: "customerUserId")
                    .map { $0 + chatrooms }
            }
    }
    
    func updateDate(chatroomId: String) -> Observable<Void> {
        let values = ["updatedAt": Date().toString(type: .timeStamp)]
        
        return firebaseStoreService.updateDocument(collection: .chatrooms, document: chatroomId, values: values)
            .asObservable()
    }

    func create(customerUserId: String, photographerUserId: String) -> Observable<String> {
        let chatroom = ChatroomDTO(
            chatroomId: UUID().uuidString,
            customerUserId: customerUserId,
            photographerUserId: photographerUserId,
            status: .activate,
            updatedAt: Date().toString(type: .timeStamp)
        )
        
        guard let values = chatroom.asDictionary else {
            return .error(FireStoreError.unknown)
        }
        
        return firebaseStoreService.createDocument(
            collection: .chatrooms,
            document: chatroom.chatroomId,
            values: values
        )
        .asObservable()
        .map { chatroom.chatroomId }
    }
    
    func create(photographerUserId: String) -> Observable<String> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.create(customerUserId: userId, photographerUserId: photographerUserId)
    }
    
    func leave(chatroomId: String) -> Single<Void> {
        return firebaseStoreService.deleteChatroom(document: chatroomId)
    }
}

private extension DefaultChatroomRepository {
    
    func observeChatrooms(userId: String, forType userType: String) -> Observable<[ChatroomDTO]> {
        return self.firebaseStoreService
            .observe(collection: .chatrooms, field: userType, in: [userId])
            .map { $0.compactMap { $0.toObject() } }
            .map { $0.sorted(by: { $0.updatedAt > $1.updatedAt }) }
    }
    
    private func fetchChatrooms(field: String) -> Observable<[Chatroom]> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return firebaseStoreService.getDocument(
            collection: .chatrooms,
            field: field,
            in: [userId]
        )
        .asObservable()
        .map { data -> [Chatroom] in
            data.compactMap { $0.toObject(ChatroomDTO.self)?.toModel() }
        }
    }
}

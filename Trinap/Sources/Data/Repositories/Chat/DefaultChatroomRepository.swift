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

    func fetch() -> Observable<[Chatroom]> {
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

    func create(customerUserId: String, photographerUserId: String) -> Observable<Void> {
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
    }
}

private extension DefaultChatroomRepository {
    
    func observeChatrooms(userId: String, forType userType: String) -> Observable<[ChatroomDTO]> {
        return self.firebaseStoreService
            .observe(collection: .chatrooms, field: userType, in: [userId])
            .map { $0.compactMap { $0.toObject() } }
    }
}

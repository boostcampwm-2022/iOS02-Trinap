//
//  DefaultChatroomRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultChatroomRepository: ChatroomRepository {

    // MARK: - Properties
    private let firebaseStoreService: FirebaseStoreService
    private let tokenManager: TokenManager

    // MARK: - Methods
    init(
        firebaseStoreService: FirebaseStoreService,
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.firebaseStoreService = firebaseStoreService
        self.tokenManager = tokenManager
    }

    func fetch() -> Observable<[Chatroom]> {
        guard let userId = tokenManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        return fetchChatrooms(userId: userId, forType: "customerUserId")
            .flatMap { [weak self] customerChatroomsDTO -> Single<[ChatroomDTO]> in
                guard let self else { return .error(FireBaseStoreError.unknown) }
                
                return self.fetchChatrooms(userId: userId, forType: "photographerUserId")
                    .map { $0 + customerChatroomsDTO }
            }
            .map { $0.map { $0.toModel() } }
            .asObservable()
    }

    func create(customerUserId: String, photographerUserId: String) -> Observable<Void> {
        let chatroom = ChatroomDTO(
            chatroomId: UUID().uuidString,
            customerUserId: customerUserId,
            photographerUserId: photographerUserId,
            status: .activate
        )
        
        guard let values = chatroom.asDictionary else {
            return .error(FireBaseStoreError.unknown)
        }
        
        return firebaseStoreService.createDocument(
            collection: "chatrooms",
            document: chatroom.chatroomId,
            values: values
        )
        .asObservable()
    }
}

private extension DefaultChatroomRepository {
    
    func fetchChatrooms(userId: String, forType userType: String) -> Single<[ChatroomDTO]> {
        return self.firebaseStoreService
            .getDocument(collection: "chatrooms", field: userType, in: [userId])
            .map { $0.compactMap { $0.toObject() } }
    }
}

//
//  DefaultChatroomRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

final class DefaultChatroomRepository: ChatroomRepository {

    // MARK: - Properties
    private let firebaseStoreService: FirebaseStoreService

    // MARK: - Methods
    init(firebaseStoreService: FirebaseStoreService) {
        self.firebaseStoreService = firebaseStoreService
    }

    func fetch() -> Single<[Chatroom]> {
        let userId = "NJwAjxZyNBDMu92wqD73"
        
        return fetchChatrooms(userId: userId, forType: "customerUserId")
            .flatMap { [weak self] customerChatroomsDTO -> Single<[ChatroomDTO]> in
                guard let self else { return .error(FireBaseStoreError.unknown) }
                
                return self.fetchChatrooms(userId: userId, forType: "photographerUserId")
                    .map { $0 + customerChatroomsDTO }
            }
            .map { $0.map { $0.toModel() } }
    }

    func create(customerUserId: String, photographerUserId: String) -> Single<Void> {
        return .just(())
    }
}

private extension DefaultChatroomRepository {
    
    func fetchChatrooms(userId: String, forType userType: String) -> Single<[ChatroomDTO]> {
        return self.firebaseStoreService
            .getDocument(collection: "chatrooms", field: userType, in: [userId])
            .map { $0.compactMap { $0.toObject() } }
    }
}

//
//  DefaultChatRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultChatRepository: ChatRepository {
    
    // MARK: - Properties
    private let firestoreService: FirebaseStoreService
    private let tokenManager: TokenManager
    
    // MARK: - Methods
    init(
        firestoreService: FirebaseStoreService,
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.firestoreService = firestoreService
        self.tokenManager = tokenManager
    }
    
    func observe(chatroomId: String) -> Observable<[Chat]> {
        return self.firestoreService
            .observe(documents: ["chatrooms", chatroomId, "chats"])
            .map { $0.compactMap { $0.toObject(ChatDTO.self)?.toModel() } }
            .asObservable()
    }
}

//
//  DefaultObserveChatUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultObserveChatUseCase: ObserveChatUseCase {
    
    // MARK: - Properties
    private let chatRepository: ChatRepository
    private let userRepository: UserRepository
    
    // MARK: - Methods
    init(
        chatRepository: ChatRepository,
        userRepository: UserRepository
    ) {
        self.chatRepository = chatRepository
        self.userRepository = userRepository
    }
    
    func execute(chatroomId: String) -> Observable<[Chat]> {
        return self.chatRepository.observe(chatroomId: chatroomId)
            .withUnretained(self)
            .flatMap { owner, chats in
                let userIds = chats
                    .map { $0.senderUserId }
                    .removingDuplicates()
                
                return owner.userRepository.fetchUsersWithMine(userIds: userIds)
                    .map { users in return owner.mapChatWithUser(chats: chats, users: users) }
            }
    }
}

// MARK: - Privates
private extension DefaultObserveChatUseCase {
    
    func mapChatWithUser(chats: [Chat], users: [User]) -> [Chat] {
        var mappedChats: [Chat] = []
        
        chats.forEach { chat in
            users.forEach { user in
                if chat.senderUserId == user.userId {
                    var mutableChat = chat
                    mutableChat.user = user
                    mappedChats.append(mutableChat)
                }
            }
        }
        
        return mappedChats
    }
}

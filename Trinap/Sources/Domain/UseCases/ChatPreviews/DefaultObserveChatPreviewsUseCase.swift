//
//  DefaultObserveChatPreviewsUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultObserveChatPreviewsUseCase: ObserveChatPreviewsUseCase {
    
    // MARK: - Properties
    private let chatroomRepository: ChatroomRepository
    private let userRepository: UserRepository
    
    // MARK: - Methods
    init(
        chatroomRepository: ChatroomRepository,
        userRepository: UserRepository
    ) {
        self.chatroomRepository = chatroomRepository
        self.userRepository = userRepository
    }
    
    func execute() -> Observable<[ChatPreview]> {
        return chatroomRepository.observe()
            .withUnretained(self)
            .flatMap { owner, chatrooms -> Observable<[ChatPreview]> in
                let chatrooms = chatrooms.filter { $0.status == .activate }
                
                let customerUserIds = chatrooms.map { $0.customerUserId }
                let photographerUserIds = chatrooms.map { $0.photographerUserId }
                
                return owner.userRepository
                    .fetchUsers(userIds: customerUserIds + photographerUserIds)
                    .withUnretained(self)
                    .map { owner, users in
                        return owner.mapChatPreview(chatrooms: chatrooms, users: users)
                    }
            }
    }
}

private extension DefaultObserveChatPreviewsUseCase {
    
    func mapChatPreview(chatrooms: [Chatroom], users: [User]) -> [ChatPreview] {
        var chatPreviews: [ChatPreview] = []
        
        for user in users {
            for chatroom in chatrooms {
                if user.userId == chatroom.customerUserId || user.userId == chatroom.photographerUserId {
                    let chatPreview = ChatPreview(
                        chatroomId: chatroom.chatroomId,
                        profileImage: user.profileImage,
                        nickname: user.nickname,
                        chatType: .text,
                        content: "",
                        date: chatroom.updatedAt,
                        isChecked: false
                    )
                    
                    chatPreviews.append(chatPreview)
                }
            }
        }
        
        return chatPreviews
    }
}

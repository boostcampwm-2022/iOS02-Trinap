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
        return chatroomRepository.fetch()
            .withUnretained(self)
            .flatMap { owner, chatrooms -> Observable<[ChatPreview]> in
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
        
        // TODO: 로직 깔끔하게 처리해보기
        // TODO: content, date, isChecked 업데이트하기
        for user in users {
            for chatroom in chatrooms {
                if user.userId == chatroom.customerUserId || user.userId == chatroom.photographerUserId {
                    let chatPreview = ChatPreview(
                        chatroomId: chatroom.chatroomId,
                        profileImage: user.profileImage,
                        nickname: user.nickname,
                        content: "네?",
//                        date: Date(),
                        isChecked: .random()
                    )
                    
                    chatPreviews.append(chatPreview)
                }
            }
        }
        
        return chatPreviews
    }
}

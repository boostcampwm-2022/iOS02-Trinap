//
//  DefaultSendChatUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

final class DefaultSendChatUseCase: SendChatUseCase {
    
    // MARK: - Properties
    private let chatRepository: ChatRepository
    
    // MARK: - Initializers
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    // MARK: - Methods
    func execute(chatType: Chat.ChatType, content: String, chatroomId: String) -> Observable<Void> {
        return chatRepository.send(chatType: chatType, content: content, at: chatroomId)
    }
    
    func execute(imageURL: String, chatroomId: String, imageWidth: Double, imageHeight: Double) -> Observable<Void> {
        return chatRepository.send(
            imageURL: imageURL,
            chatroomId: chatroomId,
            imageWidth: imageWidth,
            imageHeight: imageHeight
        )
    }
}

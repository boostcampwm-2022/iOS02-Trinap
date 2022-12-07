//
//  DefaultSendFirstChatUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultSendFirstChatUseCase: SendFirstChatUseCase {

    // MARK: Properties
    private let chatRepository: ChatRepository
    
    // MARK: Initializers
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    // MARK: Methods
    func send(chatroomId: String, reservationId: String) -> Observable<Void> {
        return chatRepository.send(
            chatType: .reservation,
            content: reservationId,
            at: chatroomId
        )
    }
}

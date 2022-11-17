//
//  DefaultObserveLastChatUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultObserveLastChatUseCase: ObserveLastChatUseCase {
    
    // MARK: - Properties
    private let chatUseCase: ChatRepository
    
    // MARK: - Methods
    init(chatUseCase: ChatRepository) {
        self.chatUseCase = chatUseCase
    }
    
    func execute(chatroomId: String) -> Observable<Chat> {
        return self.chatUseCase
            .observe(chatroomId: chatroomId)
            .compactMap { $0.last }
    }
}

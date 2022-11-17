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
    
    // MARK: - Methods
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func execute(chatroomId: String) -> Observable<[Chat]> {
        self.chatRepository.observe(chatroomId: chatroomId)
    }
}

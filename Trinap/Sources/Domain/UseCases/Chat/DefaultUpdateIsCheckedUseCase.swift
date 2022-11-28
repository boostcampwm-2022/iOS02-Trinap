//
//  DefaultUpdateIsCheckedUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

final class DefaultUpdateIsCheckedUseCase: UpdateIsCheckedUseCase {
    
    // MARK: - Properties
    private let chatRepository: ChatRepository
    
    // MARK: - Initializers
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    // MARK: - Methods
    func execute(chatroomId: String, chatId: String, toState state: Bool) -> Observable<Void> {
        return chatRepository.updateIsChecked(chatroomId: chatroomId, chatId: chatId, toState: state)
    }
}

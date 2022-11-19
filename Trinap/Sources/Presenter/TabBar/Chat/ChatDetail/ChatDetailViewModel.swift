//
//  ChatDetailViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class ChatDetailViewModel: ViewModelType {
    
    struct Input {
        var didSendWithContent: Signal<String>
    }
    
    struct Output {
        var chats: Observable<[Chat]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let chats = BehaviorRelay<[Chat]>(value: [])
    
    private let chatroomId: String
    private let observeChatUseCase: ObserveChatUseCase
    private let sendChatUseCase: SendChatUseCase
    
    // MARK: - Initializer
    init(
        chatroomId: String,
        observeChatUseCase: ObserveChatUseCase,
        sendChatUseCase: SendChatUseCase
    ) {
        self.chatroomId = chatroomId
        self.observeChatUseCase = observeChatUseCase
        self.sendChatUseCase = sendChatUseCase
        
        observeChatUseCase.execute(chatroomId: chatroomId)
            .bind(to: chats)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.didSendWithContent
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, chat -> Observable<Void> in
                return owner.sendChat(chat)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        let chats = observeChatUseCase.execute(chatroomId: self.chatroomId)

        return Output(chats: chats)
    }
}

// MARK: - Privates
private extension ChatDetailViewModel {
    
    func sendChat(_ chat: String) -> Observable<Void> {
        return sendChatUseCase.execute(chatType: .text, content: chat, chatroomId: chatroomId)
            .debug()
    }
}

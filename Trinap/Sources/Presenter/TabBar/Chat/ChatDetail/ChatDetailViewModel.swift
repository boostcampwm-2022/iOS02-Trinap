//
//  ChatDetailViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

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
    private let uploadImageUseCase: UploadImageUseCase
    
    // MARK: - Initializer
    init(
        chatroomId: String,
        observeChatUseCase: ObserveChatUseCase,
        sendChatUseCase: SendChatUseCase,
        uploadImageUseCase: UploadImageUseCase
    ) {
        self.chatroomId = chatroomId
        self.observeChatUseCase = observeChatUseCase
        self.sendChatUseCase = sendChatUseCase
        self.uploadImageUseCase = uploadImageUseCase
        
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
    
    func hasMyChat(before index: Int) -> Bool {
        guard let prevChat = self.chats.value[safe: index - 1] else { return false }
        let currentChat = self.chats.value[index]
        
        return prevChat.senderUserId == currentChat.senderUserId
    }
    
    func uploadImageAndSendChat(_ imageData: Data) -> Observable<Void> {
        return uploadImageUseCase.execute(imageData)
            .withUnretained(self)
            .flatMap { owner, imageURL in
                return owner.sendImageChat(imageURL)
            }
    }
}

// MARK: - Privates
private extension ChatDetailViewModel {
    
    func sendChat(_ chat: String) -> Observable<Void> {
        return sendChatUseCase.execute(chatType: .text, content: chat, chatroomId: chatroomId)
    }
    
    func sendImageChat(_ imageURL: String) -> Observable<Void> {
        return sendChatUseCase.execute(chatType: .image, content: imageURL, chatroomId: chatroomId)
    }
}

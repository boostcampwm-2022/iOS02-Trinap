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
    private var chats: [Chat] = []
    
    private weak var coordinator: ChatCoordinator?
    private let chatroomId: String
    private let observeChatUseCase: ObserveChatUseCase
    private let sendChatUseCase: SendChatUseCase
    private let uploadImageUseCase: UploadImageUseCase
    private let updateIsCheckedUseCase: UpdateIsCheckedUseCase
    
    // MARK: - Initializer
    init(
        coordinator: ChatCoordinator,
        chatroomId: String,
        observeChatUseCase: ObserveChatUseCase,
        sendChatUseCase: SendChatUseCase,
        uploadImageUseCase: UploadImageUseCase,
        updateIsCheckedUseCase: UpdateIsCheckedUseCase
    ) {
        self.coordinator = coordinator
        self.chatroomId = chatroomId
        self.observeChatUseCase = observeChatUseCase
        self.sendChatUseCase = sendChatUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.updateIsCheckedUseCase = updateIsCheckedUseCase
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
            .map { [weak self] chats -> [Chat] in
                guard
                    let self = self,
                    let lastChat = chats.last
                else {
                    return []
                }
                
                self.chats = chats
                if lastChat.senderType != .mine {
                    self.updateChatToRead(lastChatId: lastChat.chatId)
                }
                
                return chats
            }
        
        return Output(chats: chats)
    }
    
    func hasMyChat(before index: Int) -> Bool {
        guard
            let prevChat = self.chats[safe: index - 1],
            let currentChat = self.chats[safe: index]
        else { return false }
        
        return prevChat.senderUserId == currentChat.senderUserId
    }
    
    func uploadImageAndSendChat(_ imageData: Data, width: Double, height: Double) -> Observable<Void> {
        return uploadImageUseCase.execute(imageData)
            .withUnretained(self)
            .flatMap { owner, imageURL in
                return owner.sendImageChat(imageURL, width: width, height: height)
            }
    }
    
    func lastChatIndex() -> Int {
        if chats.isEmpty {
            return 0
        } else {
            return chats.count - 1
        }
    }
    
    func sendLocationShareChatAndPresent() -> Observable<Void> {
        return self.sendLocationShareChat()
            .withUnretained(self) { owner, _ in
                owner.presentLocationShare()
            }
    }
    
    func presentLocationShare() {
        coordinator?.showLocationShareViewController(chatroomId: chatroomId)
    }
}

// MARK: - Privates
private extension ChatDetailViewModel {
    
    func sendChat(_ chat: String) -> Observable<Void> {
        return sendChatUseCase.execute(chatType: .text, content: chat, chatroomId: chatroomId)
    }
    
    func sendImageChat(_ imageURL: String, width: Double, height: Double) -> Observable<Void> {
        return sendChatUseCase.execute(
            imageURL: imageURL,
            chatroomId: chatroomId,
            imageWidth: width,
            imageHeight: height
        )
    }
    
    func sendLocationShareChat() -> Observable<Void> {
        return sendChatUseCase.execute(chatType: .location, content: "location", chatroomId: chatroomId)
    }
    
    func updateChatToRead(lastChatId: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            guard let self else { return }
            
            self.updateIsCheckedUseCase.execute(chatroomId: self.chatroomId, chatId: lastChatId, toState: true)
                .subscribe()
                .dispose()
        }
    }
}

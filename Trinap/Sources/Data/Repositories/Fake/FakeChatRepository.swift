//
//  FakeChatRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

final class FakeChatRepository: ChatRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    let chats = BehaviorRelay<[Chat]>(value: [])
    let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(isSucceedCase: Bool) {
        self.isSucceedCase = isSucceedCase
        
        Observable<Int>.timer(.seconds(1), period: .seconds(7), scheduler: MainScheduler.asyncInstance )
            .subscribe(onNext: { [weak self] count in
                let chat = Chat.stub(
                    senderType: .other,
                    chatType: .text,
                    content: "Created Chat \(count), " + .random,
                    isChecked: false
                )
                
                var chats = self?.chats.value ?? []
                chats.append(chat)
                
                self?.chats.accept(chats)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    func observe(chatroomId: String) -> Observable<[Chat]> {
        if !isSucceedCase {
            return .error(FakeError.unknown)
        }
        return chats.asObservable()
    }
    
    func send(chatType: Chat.ChatType, content: String, at chatroomId: String) -> Observable<Void> {
        let chat = Chat.stub(chatType: chatType, content: content)
        
        var chats = self.chats.value
        chats.append(chat)
        
        self.chats.accept(chats)
        
        return execute(successValue: ())
    }
    
    func send(imageURL: String, chatroomId: String, imageWidth: Double, imageHeight: Double) -> Observable<Void> {
        let chat = Chat.stub(chatType: .image, content: imageURL, imageWidth: imageWidth, imageHeight: imageHeight)
        
        var chats = self.chats.value
        chats.append(chat)
        
        self.chats.accept(chats)
        
        return execute(successValue: ())
    }
    
    func updateIsChecked(chatroomId: String, chatId: String, toState state: Bool) -> Observable<Void> {
        var chats = self.chats.value
        
        guard let index = chats.firstIndex(where: { $0.chatId == chatId }) else {
            return .error(FakeError.unknown)
        }
        let currentChat = chats[index]
        let chat = Chat.stub(
            chatId: currentChat.chatId,
            senderUserId: currentChat.senderUserId,
            senderType: currentChat.senderType,
            chatType: currentChat.chatType,
            content: currentChat.content,
            isChecked: state,
            createdAt: currentChat.createdAt,
            imageWidth: currentChat.imageWidth,
            imageHeight: currentChat.imageHeight
        )
        chats[index] = chat
        
        self.chats.accept(chats)
        return execute(successValue: ())
    }
}

extension Chat {
    
    static func stub(
        chatId: String = UUID().uuidString,
        senderUserId: String = "userId1",
        senderType: SenderType = .mine,
        chatType: ChatType = .text,
        content: String = .random,
        isChecked: Bool = true,
        createdAt: Date = Date(),
        imageWidth: Double? = nil,
        imageHeight: Double? = nil
    ) -> Chat {
        return Chat(
            chatId: chatId,
            senderUserId: senderUserId,
            senderType: senderType,
            chatType: chatType,
            content: content,
            isChecked: isChecked,
            createdAt: createdAt,
            imageWidth: imageWidth,
            imageHeight: imageHeight
        )
    }
}

//
//  ChatPreviewsViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChatPreviewsViewModel: ViewModelType {
    
    struct Input {}
    
    struct Output {
        var chatPreviews: Driver<[ChatPreview]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ChatCoordinator?
    private let observeChatPreviewsUseCase: ObserveChatPreviewsUseCase
    private let observeChatUseCase: ObserveChatUseCase
    
    // MARK: - Initializer
    init(
        coordinator: ChatCoordinator,
        observeChatPreviewsUseCase: ObserveChatPreviewsUseCase,
        observeChatUseCase: ObserveChatUseCase
    ) {
        self.coordinator = coordinator
        self.observeChatPreviewsUseCase = observeChatPreviewsUseCase
        self.observeChatUseCase = observeChatUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        return Output(chatPreviews: observeChatPreviews())
    }
    
    func lastChatPreviewObserver(of chatPreview: ChatPreview) -> Driver<ChatPreview> {
        return observeChatUseCase.execute(chatroomId: chatPreview.chatroomId)
            .compactMap { $0.last }
            .withUnretained(self) { $0.mapChatToChatPreview(chat: $1, baseChatPreview: chatPreview) }
            .asDriver(onErrorJustReturn: .onError)
    }
    
    func showChatDetail(of chatPreview: ChatPreview) {
        coordinator?.showChatDetailViewController(chatroomId: chatPreview.chatroomId)
    }
}

// MARK: - Privates
extension ChatPreviewsViewModel {
    
    private func observeChatPreviews() -> Driver<[ChatPreview]> {
        return observeChatPreviewsUseCase.execute()
            .map { $0.sorted(by: >) }
            .asDriver(onErrorJustReturn: [.onError])
    }
    
    private func mapChatToChatPreview(chat: Chat, baseChatPreview: ChatPreview) -> ChatPreview {
        var chatPreview = baseChatPreview
        
        chatPreview.content = chat.content
        if chat.senderType == .mine {
            chatPreview.isChecked = true
        } else {
            chatPreview.isChecked = chat.isChecked
        }
        chatPreview.chatType = chat.chatType
        
        switch chatPreview.chatType {
        case .text:
            chatPreview.content = chat.content
        case .image:
            chatPreview.content = "이미지를 보냈습니다."
        case .reservation:
            chatPreview.content = "고객님이 예약을 요청했습니다."
        case .location:
            chatPreview.content = "위치 공유를 요청했습니다."
        }
        
        return chatPreview
    }
}

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
    
    private let observeChatPreviewsUseCase: ObserveChatPreviewsUseCase
    private let observeChatUseCase: ObserveChatUseCase
    
    // MARK: - Initializer
    init(
        observeChatPreviewsUseCase: ObserveChatPreviewsUseCase,
        observeChatUseCase: ObserveChatUseCase
    ) {
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
}

// MARK: - Privates
extension ChatPreviewsViewModel {
    
    private func observeChatPreviews() -> Driver<[ChatPreview]> {
        return observeChatPreviewsUseCase.execute()
            .asDriver(onErrorJustReturn: [])
    }
    
    private func mapChatToChatPreview(chat: Chat, baseChatPreview: ChatPreview) -> ChatPreview {
        var chatPreview = baseChatPreview
        
        chatPreview.content = chat.content
        chatPreview.isChecked = chat.isChecked
        return chatPreview
    }
}

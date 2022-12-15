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
    
    struct Input {
        var leaveTrigger: PublishRelay<Int>
    }
    
    struct Output {
        var chatPreviews: Driver<[ChatPreview]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ChatCoordinator?
    private let observeChatPreviewsUseCase: ObserveChatPreviewsUseCase
    private let observeChatUseCase: ObserveChatUseCase
    private let leaveChatroomUseCase: LeaveChatroomUseCase
    
    // MARK: - Initializer
    init(
        coordinator: ChatCoordinator,
        observeChatPreviewsUseCase: ObserveChatPreviewsUseCase,
        observeChatUseCase: ObserveChatUseCase,
        leaveChatroomUseCase: LeaveChatroomUseCase
    ) {
        self.coordinator = coordinator
        self.observeChatPreviewsUseCase = observeChatPreviewsUseCase
        self.observeChatUseCase = observeChatUseCase
        self.leaveChatroomUseCase = leaveChatroomUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let previews = observeChatPreviews().share()
        
        input.leaveTrigger
            .withLatestFrom(previews) { ($0, $1) }
            .compactMap { index, chatPreviews in
                return chatPreviews[safe: index]?.chatroomId
            }
            .withUnretained(self)
            .flatMap { owner, chatroomId in
                return owner.leaveChatroomUseCase.execute(chatroomId: chatroomId)
            }
            .subscribe(onError: { [weak self] _ in
                self?.coordinator?.presentErrorAlert()
            })
            .disposed(by: disposeBag)
        
        return Output(chatPreviews: previews.asDriver(onErrorJustReturn: [.onError]))
    }
    
    func lastChatPreviewObserver(of chatPreview: ChatPreview) -> Driver<ChatPreview> {
        return observeChatUseCase.execute(chatroomId: chatPreview.chatroomId)
            .compactMap { $0.last }
            .withUnretained(self) { $0.mapChatToChatPreview(chat: $1, baseChatPreview: chatPreview) }
            .asDriver(onErrorJustReturn: .onError)
    }
    
    func showChatDetail(of chatPreview: ChatPreview) {
        coordinator?.showChatDetailViewController(chatroomId: chatPreview.chatroomId, nickname: chatPreview.nickname)
    }
}

// MARK: - Privates
extension ChatPreviewsViewModel {
    
    private func observeChatPreviews() -> Observable<[ChatPreview]> {
        return observeChatPreviewsUseCase.execute()
            .map { $0.sorted(by: >) }
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

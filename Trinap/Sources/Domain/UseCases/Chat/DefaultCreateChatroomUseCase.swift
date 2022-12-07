//
//  DefaultCreateChatroomUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultCreateChatroomUseCase: CreateChatroomUseCase {
        
    // MARK: Properties
    private let chatroomRepository: ChatroomRepository
    
    // MARK: Initializers
    init(chatroomRepository: ChatroomRepository) {
        self.chatroomRepository = chatroomRepository
    }
    
    // MARK: Methods
    func create(photographerUserId: String) -> Observable<String> {
        chatroomRepository.fetchChatrooms()
            .map {
                $0.filter { $0.photographerUserId == photographerUserId || $0.customerUserId == photographerUserId }
            }
            .withUnretained(self)
            .flatMap { owner, chatrooms -> Observable<String> in
                guard let chatroom = chatrooms.first
                else {
                    return owner.chatroomRepository.create(photographerUserId: photographerUserId)
                }
                return Observable.just(chatroom.chatroomId)
            }
    }
}

//
//  FakeChatroomRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

#if DEBUG
final class FakeChatroomRepository: ChatroomRepository, FakeRepositoryType {
    
    // MARK: - Properties
    var isSucceedCase: Bool
    
    // MARK: - Initializer
    init(isSucceedCase: Bool = FakeRepositoryEnvironment.isSucceedCase) {
        self.isSucceedCase = isSucceedCase
    }
    
    // MARK: - Methods
    func observe() -> Observable<[Chatroom]> {
        var chatrooms: [Chatroom] = []
        
        for i in 1...Int.random(in: 20...40) {
            let chatroom = Chatroom.stub(chatroomId: "chatroomId\(i)")
            
            chatrooms.append(chatroom)
        }
        
        return execute(successValue: chatrooms)
    }
    
    func fetchChatrooms() -> Observable<[Chatroom]> {
        var chatrooms: [Chatroom] = []
        
        for i in 1...Int.random(in: 20...40) {
            let chatroom = Chatroom.stub(chatroomId: "chatroomId\(i)")
            
            chatrooms.append(chatroom)
        }
        
        return execute(successValue: chatrooms)
    }
    
    func updateDate(chatroomId: String) -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func create(customerUserId: String, photographerUserId: String) -> Observable<String> {
        return execute(successValue: UUID().uuidString)
    }
    
    func create(photographerUserId: String) -> Observable<String> {
        return execute(successValue: UUID().uuidString)
    }
    
    func leave(chatroomId: String) -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
}

extension Chatroom {
    
    static func stub(
        chatroomId: String = UUID().uuidString,
        customerUserId: String = "userId1",
        photographerUserId: String = "userId2",
        status: Status = .activate,
        updatedAt: Date = Date()
    ) -> Chatroom {
        return Chatroom(
            chatroomId: chatroomId,
            customerUserId: customerUserId,
            photographerUserId: photographerUserId,
            status: status,
            updatedAt: updatedAt
        )
    }
}
#endif

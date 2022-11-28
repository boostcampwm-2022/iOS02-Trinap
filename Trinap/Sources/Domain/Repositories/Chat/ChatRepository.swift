//
//  ChatRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol ChatRepository {
    
    // MARK: - Methods
    func observe(chatroomId: String) -> Observable<[Chat]>
    func send(chatType: Chat.ChatType, content: String, at chatroomId: String) -> Observable<Void>
    func send(imageURL: String, chatroomId: String, imageWidth: Double, imageHeight: Double) -> Observable<Void>
}

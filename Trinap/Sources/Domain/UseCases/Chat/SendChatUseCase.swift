//
//  SendChatUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol SendChatUseCase {
    
    func execute(chatType: Chat.ChatType, content: String, chatroomId: String) -> Observable<Void>
    func execute(imageURL: String, chatroomId: String, imageWidth: Double, imageHeight: Double) -> Observable<Void>
}

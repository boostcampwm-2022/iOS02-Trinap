//
//  Chat.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Chat {
    
    enum ChatType: String, Codable {
        case text
        case image
        case reservation
        case location
    }
    
    enum SenderType {
        case mine
        case other
    }
    
    // MARK: - Properties
    let chatId: String
    let senderUserId: String
    let senderType: SenderType
    let chatType: ChatType
    let content: String
    let isChecked: Bool
    let createdAt: Date
    
    // TODO: Optional 제거한 다른 타입 생성하기
    var user: User?
}

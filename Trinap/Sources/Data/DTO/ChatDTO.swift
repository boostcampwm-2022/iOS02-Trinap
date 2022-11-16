//
//  ChatDTO.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ChatDTO: Codable {
    
    enum ChatType: String, Codable {
        case text
        case image
        case reservation
        case location
    }
    
    // MARK: - Properties
    let chatId: String
    let senderUserId: String
    let chatType: ChatType
    let content: String
    let isChecked: Bool
//    let createdAt: Date
    
    // MARK: - Methods
    func toModel() -> Chat {
        return Chat(
            chatId: chatId,
            senderUserId: senderUserId,
            chatType: chatType,
            content: content,
            isChecked: isChecked//,
//            createdAt: createdAt
        )
    }
}

//
//  ChatDTO.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ChatDTO: Codable {
    
    // MARK: - Properties
    let chatId: String
    let senderUserId: String
    let chatType: Chat.ChatType
    let content: String
    let isChecked: Bool
    let createdAt: String
    
    // MARK: - Methods
    func toModel(clientId: String) -> Chat {
        return Chat(
            chatId: chatId,
            senderUserId: senderUserId,
            senderType: getSenderType(clientId: clientId),
            chatType: chatType,
            content: content,
            isChecked: isChecked,
            createdAt: Date.fromStringOrNow(createdAt)
        )
    }
    
    private func getSenderType(clientId: String) -> Chat.SenderType {
        if clientId == self.senderUserId {
            return .mine
        } else {
            return .other
        }
    }
}

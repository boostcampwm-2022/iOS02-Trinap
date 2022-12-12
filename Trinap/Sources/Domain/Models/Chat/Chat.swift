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
    let imageWidth: Double?
    let imageHeight: Double?
    
    var user: User?
}

extension Chat: Hashable {}

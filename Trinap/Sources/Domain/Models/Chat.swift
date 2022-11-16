//
//  Chat.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Chat {
    
    // MARK: - Properties
    let chatId: String
    let senderUserId: String
    let chatType: ChatDTO.ChatType
    let content: String
    let isChecked: Bool
//    let createdAt: Date
}

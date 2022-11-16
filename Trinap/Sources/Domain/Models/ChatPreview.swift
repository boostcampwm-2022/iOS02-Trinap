//
//  ChatPreview.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ChatPreview {
    
    // MARK: - Properties
    let chatroomId: String
    let profileImage: URL?
    let nickname: String
    var content: String
    var date: Date
    var isChecked: Bool
}

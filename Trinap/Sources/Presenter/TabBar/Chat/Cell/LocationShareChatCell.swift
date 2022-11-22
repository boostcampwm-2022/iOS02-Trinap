//
//  LocationShareChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class LocationShareChatCell: ActionChatCell {
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureCell(by chat: Chat, hasMyChatBefore: Bool, completion: (() -> Void)? = nil) {
        super.configureCell(by: chat, hasMyChatBefore: hasMyChatBefore, completion: completion)
        
        guard let user = chat.user else { return }
        
        self.contentLabel.text = "\(user.nickname) 님이 위치 공유를 요청했습니다."
        self.actionButton.style = .black
        self.actionButton.setTitle("위치 공유하기", for: .normal)
    }
}

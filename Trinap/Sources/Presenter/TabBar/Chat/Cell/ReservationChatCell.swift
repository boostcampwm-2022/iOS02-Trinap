//
//  ReservationChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class ReservationChatCell: ActionChatCell {
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureCell(by chat: Chat, hasMyChatBefore: Bool, completion: (() -> Void)? = nil) {
        super.configureCell(by: chat, hasMyChatBefore: hasMyChatBefore, completion: completion)
        
        guard let user = chat.user else { return }
        
        self.contentLabel.text = "\(user.nickname) 님이 예약을 요청했습니다."
        self.actionButton.style = .secondary
        self.actionButton.setTitle("예약 확인", for: .normal)
    }
}

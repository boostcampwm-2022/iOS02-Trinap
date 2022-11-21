//
//  TextChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/20.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class TextChatCell: ChatCell {
    
    // MARK: - Properties
    private lazy var chatLabel: UILabel = {
        let label = UILabel()
        
        label.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = TrinapAsset.black.color
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.chatContentView.addSubview(chatLabel)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        chatLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureCell(by chat: Chat) {
        super.configureCell(by: chat)
        
        self.chatLabel.text = chat.content
    }
}

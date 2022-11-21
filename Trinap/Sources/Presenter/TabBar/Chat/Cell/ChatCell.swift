//
//  ChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/20.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

class ChatCell: BaseTableViewCell {
    
    // MARK: - Properties
    lazy var profileImageView: ProfileImageView = {
        let profileImageView = ProfileImageView()
        
        return profileImageView
    }()
    
    lazy var chatContentView: ChatContentView = {
        let chatContentView = ChatContentView()
        
        return chatContentView
    }()
    
    // MARK: - Initializer
    
    // MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
    }
    
    override func configureHierarchy() {
        self.addSubviews([
            profileImageView,
            chatContentView
        ])
    }
    
    override func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        chatContentView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-100)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configureCell(by chat: Chat) {
        self.profileImageView.setImage(at: chat.user?.profileImage)
        self.chatContentView.sender = chat.senderType
    }
}

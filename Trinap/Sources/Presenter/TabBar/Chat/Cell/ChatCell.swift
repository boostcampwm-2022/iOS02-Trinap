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
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(28)
        }
        
        configureLayoutAsOther()
    }
    
    func configureCell(by chat: Chat) {
        self.profileImageView.setImage(at: chat.user?.profileImage)
        self.chatContentView.sender = chat.senderType
        self.reconfigureLayout(by: chat.senderType)
    }
}

// MARK: - Privates
private extension ChatCell {
    
    private func reconfigureLayout(by senderType: Chat.SenderType) {
        if senderType == .mine {
            self.configureLayoutAsMine()
        } else {
            self.configureLayoutAsOther()
        }
    }
    
    private func configureLayoutAsMine() {
        profileImageView.isHidden = true
        chatContentView.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.leading.greaterThanOrEqualToSuperview().offset(100)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func configureLayoutAsOther() {
        profileImageView.isHidden = false
        chatContentView.snp.remakeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-100)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
}

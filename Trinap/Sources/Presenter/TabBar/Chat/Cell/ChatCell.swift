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
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(28)
        }
        
        configureLayoutAsOther(hasMyChatBefore: false)
    }
    
    func configureCell(by chat: Chat, hasMyChatBefore: Bool, completion: (() -> Void)? = nil) {
        self.profileImageView.setImage(at: chat.user?.profileImage)
        self.chatContentView.sender = chat.senderType
        self.reconfigureLayout(
            by: chat.senderType,
            hasMyChatBefore: hasMyChatBefore
        )
        completion?()
    }
}

// MARK: - Privates
private extension ChatCell {
    
    private func reconfigureLayout(
        by senderType: Chat.SenderType,
        hasMyChatBefore: Bool
    ) {
        if senderType == .mine {
            self.configureLayoutAsMine(hasMyChatBefore: hasMyChatBefore)
        } else {
            self.configureLayoutAsOther(hasMyChatBefore: hasMyChatBefore)
        }
    }
    
    private func configureLayoutAsMine(hasMyChatBefore: Bool) {
        profileImageView.isHidden = true
        let topInset = topInset(when: hasMyChatBefore)
        chatContentView.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.leading.greaterThanOrEqualToSuperview().offset(100)
            make.bottom.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(topInset)
        }
    }
    
    private func configureLayoutAsOther(hasMyChatBefore: Bool) {
        profileImageView.isHidden = hasMyChatBefore
        let topInset = topInset(when: hasMyChatBefore)
        chatContentView.snp.remakeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-100)
            make.bottom.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(topInset)
        }
    }
    
    private func topInset(when hasMyChatBefore: Bool) -> CGFloat {
        if hasMyChatBefore {
            return 0
        } else {
            return 8
        }
    }
}

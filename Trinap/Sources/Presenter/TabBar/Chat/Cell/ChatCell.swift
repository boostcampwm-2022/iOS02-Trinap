//
//  ChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/20.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import RxRelay
import RxSwift

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
    
    let reportTrigger = PublishRelay<Void>()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
        self.profileImageView.image = nil
    }
    
    override func configureHierarchy() {
        self.contentView.addSubviews([
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
    
    override func configureAttributes() {
        super.configureAttributes()
        
        let reportInteraction = UIContextMenuInteraction(delegate: self)
        chatContentView.addInteraction(reportInteraction)
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

// MARK: - UIContextMenu Interaction Delegate
extension ChatCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider: { _ in
            let reportAction = UIAction(title: "신고하기", attributes: .destructive) { [weak self] _ in
                self?.reportTrigger.accept(())
            }
            
            return UIMenu(children: [reportAction])
        })
        
        return config
    }
}

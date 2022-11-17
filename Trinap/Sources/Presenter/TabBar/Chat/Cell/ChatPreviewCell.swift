//
//  ChatPreviewCell.swift
//  TrinapTests
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ChatPreviewCell: BaseTableViewCell {
    
    // MARK: - UI
    private lazy var profileImageView: ProfileImageView = {
        let profileImageView = ProfileImageView()
        
        return profileImageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = TrinapAsset.black.color
        return label
    }()
    
    private lazy var chatPreviewLabel: UILabel = {
        let label = UILabel()
        
        label.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = TrinapAsset.subtext.color
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = TrinapFontFamily.Pretendard.regular.font(size: 12)
        label.textColor = TrinapAsset.subtext2.color
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var unreadAccessoryView: UnreadAccessoryView = {
        return UnreadAccessoryView()
    }()
    
    // MARK: - Properties
    
    // MARK: - Initializer
    
    // MARK: - Methods
    func bind(lastChatPreview: Driver<ChatPreview>) {
        lastChatPreview.drive { [weak self] chatPreview in
            guard let self else { return }
            
            self.configureCell(chatPreview)
        }
        .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.nicknameLabel.text = ""
        self.chatPreviewLabel.text = ""
        self.dateLabel.text = ""
        self.unreadAccessoryView.isHidden = true
    }
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            chatPreviewLabel,
            dateLabel,
            unreadAccessoryView
        ].forEach { self.contentView.addSubview($0) }
    }
    
    override func configureConstraints() {
        let padding = 16
        
        profileImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(padding)
            make.width.equalTo(self.profileImageView.snp.height)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(padding)
            make.top.equalToSuperview().offset(padding + 2)
        }
        
        chatPreviewLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nicknameLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-(padding + 2))
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nicknameLabel.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.centerY.equalTo(self.nicknameLabel.snp.centerY)
        }
        
        unreadAccessoryView.snp.makeConstraints { make in
            make.leading.equalTo(self.chatPreviewLabel.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.centerY.equalTo(self.chatPreviewLabel.snp.centerY)
        }
    }
}

// MARK: - Privates
extension ChatPreviewCell {
    
    private func configureCell(_ chatPreview: ChatPreview) {
        self.profileImageView.setImage(at: chatPreview.profileImage)
        self.nicknameLabel.text = chatPreview.nickname
        self.chatPreviewLabel.text = chatPreview.content
        self.dateLabel.text = chatPreview.date.properText
        self.unreadAccessoryView.isHidden = !chatPreview.isChecked
    }
}

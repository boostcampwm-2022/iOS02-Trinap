//
//  ImageChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Queenfisher

final class ImageChatCell: ChatCell {
    
    // MARK: - Properties
    private lazy var imageContentView = UIImageView().than {
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageContentView.image = nil
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.chatContentView.addSubview(imageContentView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        imageContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureCell(by chat: Chat, hasMyChatBefore: Bool, completion: (() -> Void)? = nil) {
        super.configureCell(by: chat, hasMyChatBefore: hasMyChatBefore, completion: nil)
        
        let url = URL(string: chat.content)
        let defaultSize = CGSize(width: 200, height: 200)
        self.imageContentView.qf.setImage(at: url, targetSize: defaultSize) {
            completion?()
        }
    }
}

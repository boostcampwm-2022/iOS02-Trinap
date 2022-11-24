//
//  ActionChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

class ActionChatCell: ChatCell {
    
    // MARK: - Properties
    lazy var contentLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.numberOfLines = 0
    }
    
    lazy var actionButton = TrinapButton(style: .primary, fillType: .fill)
    
    var didTapAction: ControlEvent<Void> {
        return actionButton.rx.tap
    }
    
    var actionDisposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        actionDisposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.chatContentView
            .addSubviews([contentLabel, actionButton])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        self.contentLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(12)
        }
        
        self.actionButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
            make.height.equalTo(36)
        }
    }
}

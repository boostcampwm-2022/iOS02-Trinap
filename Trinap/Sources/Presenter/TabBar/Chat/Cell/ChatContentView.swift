//
//  ChatContentView.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/20.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class ChatContentView: BaseView {
    
    // MARK: - Properties
    var sender: Chat.SenderType = .mine {
        didSet { applySenderType() }
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        applySenderType()
        self.clipsToBounds = true
        self.layer.cornerRadius = 8.0
    }
    
    // MARK: - Methods
    private func applySenderType() {
        self.backgroundColor = self.sender.backgroundColor
    }
}

// MARK: - SenderType
private extension Chat.SenderType {
    
    var backgroundColor: UIColor {
        switch self {
        case .mine:
            return TrinapAsset.background.color
        case .other:
            return TrinapAsset.sub2.color
        }
    }
}

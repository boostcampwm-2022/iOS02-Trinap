//
//  UnreadAccessoryView.swift
//  TrinapTests
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class UnreadAccessoryView: BaseView {
    
    // MARK: - Properties
    var side: CGFloat
    
    // MARK: - Initializer
    init(side: CGFloat = 8.0) {
        self.side = side
        
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = side / 2
        self.backgroundColor = TrinapAsset.primary.color
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(side)
            make.height.equalTo(side)
        }
    }
}

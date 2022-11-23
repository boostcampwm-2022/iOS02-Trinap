//
//  PaddingLabel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

//양 옆 패딩(마진)설정이 가능한 커스텀 레이블
class PaddingLabel: UILabel {
    
    var top: CGFloat = 0
    var bottom: CGFloat = 0
    var left: CGFloat = 0
    var right: CGFloat = 0
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.top = padding.top
        self.left = padding.left
        self.bottom = padding.bottom
        self.right = padding.right
    }
    
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.left + self.right
        contentSize.height += self.top + self.bottom
        
        return contentSize
    }
}

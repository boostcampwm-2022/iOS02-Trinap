//
//  CALayer+Border.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(color: UIColor = TrinapAsset.border.color, width: CGFloat = 1) {
        self.borderColor = color.cgColor
        self.borderWidth = width
    }
    
    /// **Must called after frame set. ex) layoutSubviews, viewDidAppear, ...**
    func addBorder(_ edges: [UIRectEdge], color: UIColor = TrinapAsset.border.color, width: CGFloat = 1) {
        edges.forEach { edge in
            let border = CALayer()
            
            switch edge {
            case .top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
            case .bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
            case .left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
            case .right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
            default:
                break
            }
            
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}

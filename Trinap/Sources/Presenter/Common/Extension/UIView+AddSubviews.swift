//
//  UIView+AddSubviews.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/20.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(self.addSubview)
    }
}

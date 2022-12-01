//
//  Divider.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class Divider: BaseView {
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = TrinapAsset.border.color
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}

//
//  MyPageSectionHeader.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class MyPageSectionHeader: BaseView {
    
    private lazy var titleLabel = UILabel().than {
        $0.text = "작가 설정"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.trinapOffset * 2)
        }
    }
    
    func configure(with title: String) {
        self.titleLabel.text = title
    }
}

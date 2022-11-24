//
//  TitleSectionHeaderView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Than

final class TitleSectionHeaderView: BaseCollectionReusableView {
    private lazy var titleLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = TrinapAsset.black.color
    }
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureHeaderView(title: String) {
        self.titleLabel.text = title
    }
}

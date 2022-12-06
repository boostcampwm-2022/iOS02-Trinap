//
//  WarningStackView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than
import SnapKit

final class WarningLabelView: BaseView {
    
    private lazy var stackView = UIStackView().than {
        $0.alignment = .top
        $0.axis = .horizontal
        $0.spacing = trinapOffset
        $0.distribution = .fillProportionally
    }
    
    private lazy var bulletLabel = UILabel().than {
        $0.text = "•"
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = TrinapAsset.subtext.color
    }
    
    private lazy var warningLabel = UILabel().than {
        $0.text = "주의사항!"
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = TrinapAsset.subtext.color
        $0.numberOfLines = 0
    }
    
    init(warningText: String) {
        super.init(frame: .zero)
        self.warningLabel.text = warningText
    }
    
    override func configureHierarchy() {
        self.addSubview(stackView)
        [
            bulletLabel,
            warningLabel
        ].forEach { self.stackView.addArrangedSubview($0) }
    }
    
    override func configureConstraints() {
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.backgroundColor = TrinapAsset.background.color
    }
}

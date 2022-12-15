//
//  OpenSourceCell.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Than

final class OpenSourceCell: BaseTableViewCell {
    
    // MARK: - UI
    private lazy var nameLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.black.color
    }
    
    private lazy var versionLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.black.color
    }
    
    private lazy var button = UIButton().than {
        $0.contentMode = .scaleAspectFill
        $0.imageView?.tintColor = TrinapAsset.black.color
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        self.contentView.addSubviews([
            nameLabel,
            versionLabel,
            button
        ])
    }
    
    override func configureConstraints() {
        self.nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(trinapOffset)
        }
        
        self.versionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(trinapOffset)
        }
        
        self.button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-trinapOffset)
        }
    }
    
    func configureCell(openSourceInfo: OpenSourceInfo) {
        self.nameLabel.text = openSourceInfo.name
        self.versionLabel.text = openSourceInfo.version
    }
}

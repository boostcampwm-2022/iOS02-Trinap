//
//  BlockListCell.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Than

final class BlockListCell: BaseTableViewCell {
    
    // MARK: - UI
    private lazy var profileImageView = ProfileImageView()
    
    private lazy var nicknameLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.black.color
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    lazy var blockStatusButton = TrinapButton(style: .background).than {
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 12)
        $0.setTitle("차단 해제", for: .normal)
        $0.setTitleColor(TrinapAsset.subtext.color, for: .normal)
        $0.setTitleColor(TrinapAsset.primary.color, for: .selected)
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    // MARK: - Properties
    var isBlockStatusButtonSelected = false {
        didSet {
            self.blockStatusButton.isSelected.toggle()
            configureBlockStatusButton(isBlockStatusButtonSelected)
        }
    }
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.contentView.addSubviews([
            profileImageView,
            nicknameLabel,
            blockStatusButton
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        let trinapDoubleOffset = trinapOffset * 2
        
        profileImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(trinapDoubleOffset)
            make.width.equalTo(self.profileImageView.snp.height)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(trinapDoubleOffset)
            make.trailing.lessThanOrEqualTo(self.blockStatusButton.snp.leading).offset(-trinapDoubleOffset)
            make.centerY.equalToSuperview()
        }
        
        blockStatusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-trinapDoubleOffset)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(blockedUser: Block.BlockedUser) {
        self.profileImageView.setImage(at: blockedUser.blockedUser.profileImage)
        self.nicknameLabel.text = blockedUser.blockedUser.nickname
    }
    
    private func configureBlockStatusButton(_ isSelected: Bool) {
        self.blockStatusButton.backgroundColor = isSelected ? TrinapAsset.sub1.color : TrinapAsset.background.color
    }
}

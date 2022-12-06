//
//  ContactTableViewCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class ContactTableViewCell: BaseTableViewCell {
    
    private lazy var contentsLabel = UILabel().than {
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.text = "문의하기"
    }
    
    private lazy var button = UIButton().than {
        $0.contentMode = .scaleAspectFill
        $0.imageView?.tintColor = TrinapAsset.black.color
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }
    
    override func configureHierarchy() {
        self.addSubviews([contentsLabel, button])
    }
    
    override func configureConstraints() {
        self.contentsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.centerY.equalToSuperview()
        }
        
        self.button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(trinapOffset * 3)
            make.width.height.equalTo(trinapOffset * 3)
        }
    }
    
    func configure(with contact: Contact) {
        self.contentsLabel.text = contact.title
    }
}

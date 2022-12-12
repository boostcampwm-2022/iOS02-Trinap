//
//  MyPageSwitchRow.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/09.
//  Copyright © 2022 Trinap. All rights reserved.
//
import UIKit

final class MyPageSwitchRow: BaseTableViewCell {
    
    private lazy var infoLabel = UILabel().than {
        $0.text = "작가 프로필 노출"
    }
    
    lazy var exposureSwitch = UISwitch()
    
    override func configureHierarchy() {
        self.contentView.addSubviews([infoLabel, exposureSwitch])
    }
    
    override func configureConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(trinapOffset * 2)
            make.centerY.equalToSuperview()
        }
        
        self.exposureSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
    }
    
    override func configureAttributes() {
        self.selectionStyle = .none
    }
    
    func configure(isExposure: Bool) {
        self.exposureSwitch.isOn = isExposure
    }
}

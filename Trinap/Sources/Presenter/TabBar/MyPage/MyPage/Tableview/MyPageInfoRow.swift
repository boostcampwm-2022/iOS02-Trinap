//
//  MyPageInfoRow.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class MyPageInfoCell: BaseTableViewCell {
    
    var type: MyPageCellType? {
        didSet { configure() }
    }
    
    private lazy var infoLabel = UILabel().than {
        $0.text = "작가 프로필 설정"
    }
    
    lazy var exposureSwitch = UISwitch()
    
    private lazy var versionLabel = UILabel().than {
        $0.textColor = TrinapAsset.primary.color
    }
    
    override func configureHierarchy() {
        addSubview(infoLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.versionLabel.text = nil
        self.infoLabel.text = nil
    }
    
    override func configureConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(trinapOffset * 2)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.selectionStyle = .none
    }
    
    private func configure() {
        guard let item = self.type else { return }
        self.infoLabel.text = item.title
        
        switch item {
        case .photographerExposure(isExposure: let status):
            configureToggle(with: status)
        case .version(version: let version):
            configureVersion(with: version)
        default:
            return
        }
    }
    
    private func configureToggle(with status: Bool) {
        self.exposureSwitch.isOn = status
        
        self.addSubview(exposureSwitch)
        self.exposureSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
    }
    
    private func configureVersion(with version: String) {
        self.versionLabel.text = version
        
        self.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
    }
}

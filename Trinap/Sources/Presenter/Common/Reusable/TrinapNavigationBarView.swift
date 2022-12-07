//
//  TrinapNavigationBarView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than
import SnapKit

final class TrinapNavigationBarView: BaseView {
    
    // MARK: - UI
    lazy var backButton = UIButton().than {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = TrinapAsset.black.color
    }
    
    private lazy var titleLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = TrinapAsset.black.color
    }
    
    // MARK: - Initializers
    
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(backButton)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        self.backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(trinapOffset * 2)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        self.backgroundColor = TrinapAsset.white.color
    }
    
    func setTitleText(_ text: String?) {
        self.addSubview(self.titleLabel)
        
        self.titleLabel.text = text
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func addRightButton(_ button: UIButton) {
        self.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
    }
}

//
//  PlaceHolderView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/13.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Than

final class PlaceHolderView: BaseView {
    
    // MARK: - UI
    private lazy var descriptionLabel = UILabel().than {
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    init(text: String) {
        super.init(frame: .zero)
        
        self.descriptionLabel.text = text
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(descriptionLabel)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(trinapOffset * 10)
            make.centerX.equalToSuperview()
        }
    }
    
    func updateDescriptionText(_ text: String) {
        self.descriptionLabel.text = text
    }
}

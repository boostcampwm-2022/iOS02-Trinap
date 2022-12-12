//
//  TrinapSearchBar.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/11.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class TrinapSearchBar: BaseView {
    
    // MARK: - UI
    private lazy var searchImageView = UIImageView().than {
        $0.tintColor = TrinapAsset.gray40.color
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var textField = UITextField().than {
        $0.placeholder = "추억을 만들 장소를 선택해주세요."
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    // MARK: - Properties
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = TrinapAsset.background.color
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubviews([
            searchImageView,
            textField
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        searchImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(8)
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
}

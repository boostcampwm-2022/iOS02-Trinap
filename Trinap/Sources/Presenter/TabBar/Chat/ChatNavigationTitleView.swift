//
//  ChatNavigationTitleView.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class LargeNavigationTitleView: BaseView {
    
    // MARK: - UI
    private lazy var titleView = UILabel().than {
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
    
    // MARK: - Properties
    private let title: String
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: - Initializers
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(titleView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        self.backgroundColor = .clear
        titleView.text = self.title
    }
}

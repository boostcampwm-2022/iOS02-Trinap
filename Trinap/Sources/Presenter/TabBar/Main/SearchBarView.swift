//
//  SearchBarView.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than
import SnapKit

final class SearchBarView: BaseView {
    // MARK: UI
    private lazy var searchImageView = UIImageView().than {
        $0.tintColor = TrinapAsset.gray40.color
        $0.image = UIImage(systemName: "magnifyingglass")
//        UISearchBar.Icon.search
    }
    
    lazy var searchLabel = UILabel().than {
        $0.text = "추억을 만들 장소를 선택해주세요."
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.gray40.color
    }
    
    // MARK: Properties
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: Initializers
    
    // MARK: Methods
    override func configureHierarchy() {
        self.addSubviews([
            searchImageView,
            searchLabel
        ])
    }
    
    override func configureConstraints() {
        searchImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(2 * trinapOffset)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(trinapOffset)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.layer.cornerRadius = 25
        self.backgroundColor = TrinapAsset.background.color
    }
    
    func configure(searchText: String) {
        self.searchLabel.text = searchText
    }
}

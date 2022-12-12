//
//  StarView.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than
import SnapKit

// 네이밍 추천 받읍니다..
final class StarView: BaseView {
    
    // MARK: UI
    private lazy var starImage = UIImageView().than {
        $0.image = TrinapAsset.reviewStar.image
    }
    
    private lazy var ratingLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 14)
    }
    
    // MARK: Properties
    
    // MARK: Initializers
    
    // MARK: Methods
    override func configureHierarchy() {
        self.addSubviews([
            starImage,
            ratingLabel
        ])
    }
    
    override func configureConstraints() {
        starImage.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImage.snp.trailing).offset(3)
            make.trailing.centerY.equalToSuperview()
        }
    }
    
    func configure(rating: Double) {
        ratingLabel.text = "\(rating)"
    }
}

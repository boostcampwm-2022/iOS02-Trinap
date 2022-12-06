//
//  RegisterLocationView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class RegisterLocationView: BaseView {
    
    lazy var locationLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.subtext2.color
        $0.text = "지역을 선택해주세요"
    }
    
    private lazy var indicatorImageView = UIImageView().than {
        $0.tintColor = TrinapAsset.gray40.color
        $0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
    }
    
    override func configureHierarchy() {
        self.addSubviews([locationLabel, indicatorImageView])
    }
    
    override func configureConstraints() {
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(trinapOffset * 2)
        }
        
        indicatorImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(trinapOffset * 3)
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
    }
    
    override func configureAttributes() {
        self.backgroundColor = TrinapAsset.background.color
        self.layer.cornerRadius = 8
    }
    
    func configure(text: String) {
        self.locationLabel.text = text
        self.locationLabel.textColor = text.isEmpty ? TrinapAsset.subtext2.color : TrinapAsset.black.color
    }
}

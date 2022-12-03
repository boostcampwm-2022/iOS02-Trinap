//
//  PhotographerDetailCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class PhotographerDetailIntroductionCell: BaseCollectionViewCell {
    
    private lazy var containerView = UIView().than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.layer.cornerRadius = 8
    }
    
    private lazy var timeUnitLabel = UILabel().than {
        $0.text = "1시간"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var priceLabel = UILabel().than {
        $0.text = "10000원"
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    private lazy var introduceTitleLabel = UILabel().than {
        $0.text = "소개글"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var introduceLabel = UILabel().than {
        $0.text = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et, auctor egestas sit integer.
            Vel tellus aliquam hac commodo pulvinar non nam. Amet,
            molestie orci, vivamus congue sed diam sem quisque enim. Auctor nibh commodo suspendisse eget urna,
            rutrum fames. Sed mattis cursus odio dignissim aliquam,
            laoreet placerat. Aliquam elit mauris sodales interdum in a in non ut.
            Donec elementum, feugiat ultricies est.
            Hendrerit aliquam adipiscing elit augue et convallis tempor ullamcorper nulla.
            Dictumst massa bibendum hac donec amet vitae feugiat.
            """
        $0.numberOfLines = 0
        $0.textColor = TrinapAsset.gray40.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    private lazy var precautionsTitleLabel = UILabel().than {
        $0.text = "주의 사항"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var precautionsLabel = UILabel().than {
        $0.text = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et, auctor egestas sit integer.
            Vel tellus aliquam hac commodo pulvinar non nam. Amet, molestie orci, vivamus congue sed diam
            """
        $0.numberOfLines = 0
        $0.textColor = TrinapAsset.gray40.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    override func configureHierarchy() {
        self.addSubviews([containerView, introduceLabel, introduceTitleLabel, precautionsLabel, precautionsTitleLabel])
        self.containerView.addSubviews([timeUnitLabel, priceLabel])
    }
    
    override func configureAttributes() {
        self.isUserInteractionEnabled = false
    }
    
    override func configureConstraints() {
        
        let offset = trinapOffset * 2
        
        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(trinapOffset * 6)
        }
        
        self.timeUnitLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(trinapOffset * 2)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
        
        self.introduceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(trinapOffset * 3)
            make.leading.equalToSuperview()
        }
        
        self.introduceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(introduceTitleLabel.snp.bottom).offset(offset)
        }
        
        let dividor = UIView()
        dividor.backgroundColor = TrinapAsset.background.color
        
        self.addSubview(dividor)
        dividor.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(introduceLabel.snp.bottom).offset(offset)
            make.height.equalTo(1)
        }
        
        self.precautionsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dividor).offset(offset)
        }
        
        self.precautionsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(precautionsTitleLabel.snp.bottom).offset(offset)
        }
    }
    
    func configure(with information: PhotographerUser) {
        self.introduceLabel.text = information.introduction
        self.priceLabel.text = "\(information.pricePerHalfHour)원"
    }
}

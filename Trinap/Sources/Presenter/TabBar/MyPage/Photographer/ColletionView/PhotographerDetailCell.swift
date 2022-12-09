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
        $0.text = "30분"
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
            예약과 관련된 상세한 정보는 채팅으로 정해주세요.
            채팅 시 민감한 정보 교환에 주의해주세요.
            작가의 위법행위를 발견한다면 즉시 신고해주세요.
            Trinap 외 다른 채널을 사용하여 발생한 불이익은 Trinap에서 책임지지 않습니다.
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
        self.priceLabel.text = "\(information.pricePerHalfHour ?? 0)원"
    }
}

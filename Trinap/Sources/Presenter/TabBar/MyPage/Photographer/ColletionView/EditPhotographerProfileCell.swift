//
//  EditPhotographerProfileHeaderView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift

final class EditPhotographerProfileCell: BaseCollectionViewCell {
    
    lazy var filterView = FilterView(filterMode: .photographer)
    private lazy var profileImage = ProfileImageView()
    
    private lazy var nickNameLabel = UILabel().than {
        $0.text = "어디로든떠나요"
        $0.textColor = .black
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
     
    private lazy var locationLabel = UILabel().than {
        $0.text = "서울시 성동구"
        $0.textColor = TrinapAsset.gray40.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    lazy var editButton = TrinapButton(style: .black, fillType: .border, isCircle: true).than {
        $0.setTitle("작가정보 수정", for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.regular.font(size: 12)
    }
    
    private lazy var stackView = UIStackView()
    
    override func configureHierarchy() {
        self.addSubviews([profileImage, nickNameLabel, locationLabel, editButton, filterView])
    }
    
    override func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(trinapOffset * 8)
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalToSuperview().inset(trinapOffset * 3)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(trinapOffset * 2)
            make.top.equalTo(profileImage).offset(trinapOffset / 2)
        }

        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(nickNameLabel)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(trinapOffset / 2)
        }

        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(trinapOffset * 3)
            make.height.equalTo(trinapOffset * 4)
            make.width.equalTo(trinapOffset * 10)
        }
        
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(profileImage.snp.bottom).offset(trinapOffset * 2)
            make.height.equalTo(trinapOffset * 6)
        }
    }
    
    func configure(with profile: PhotographerUser) {
        nickNameLabel.text = profile.nickname
        locationLabel.text = profile.location
        profileImage.setImage(at: profile.profileImage)
    }
}

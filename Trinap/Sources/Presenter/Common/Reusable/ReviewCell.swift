//
//  ReviewCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Than

final class ReviewCell: BaseTableViewCell {
    
    // MARK: - Properties
    private lazy var profileImageView = ProfileImageView()
    
    private lazy var nicknameLabel = UILabel().than {
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 16)
    }
    
    private lazy var dateLabel = UILabel().than {
        $0.textColor = TrinapAsset.subtext2.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 12)
    }
    
    private lazy var ratingView = RatingView(style: .view).than {
        $0.backgroundColor = TrinapAsset.white.color
    }
    
    private lazy var contentLabel = UILabel().than {
        $0.textColor = TrinapAsset.subtext.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.numberOfLines = 0
    }
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.contentView.addSubviews([
            profileImageView, nicknameLabel, dateLabel, ratingView, contentLabel
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(profileImageView.snp.top)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        ratingView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(profileImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.leading)
            make.trailing.equalTo(ratingView.snp.trailing)
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    func configureCell(_ item: UserReview) {
        self.profileImageView.setImage(at: item.user.profileImage)
        self.nicknameLabel.text = item.user.nickname
        self.dateLabel.text = item.createdAt.toString(type: .yearAndMonthAndDate)
        self.contentLabel.text = item.contents
        self.ratingView.configureRating(item.rating)
    }
}

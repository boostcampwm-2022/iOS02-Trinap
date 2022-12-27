//
//  PhotographerReivewCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class PhotographerReivewCell: BaseCollectionViewCell {
    
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
        $0.invalidateIntrinsicContentSize()
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
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(profileImageView.snp.top)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        ratingView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(profileImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.leading)
            make.trailing.equalTo(ratingView.snp.trailing)
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }

    override func configureAttributes() {
        self.isUserInteractionEnabled = false
    }
    
    func configure(with review: UserReview) {
        self.nicknameLabel.text = review.user.nickname
        self.dateLabel.text = review.createdAt.toString(type: .yearAndMonthAndDate)
        self.contentLabel.text = review.contents
        
        let newSize = contentLabel.intrinsicContentSize
        self.contentLabel.frame.size = newSize
        self.ratingView.configureRating(review.rating)
        self.profileImageView.setImage(at: review.user.profileImage)
    }
}

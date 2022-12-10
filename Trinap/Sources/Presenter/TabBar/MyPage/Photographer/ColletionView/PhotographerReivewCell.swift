//
//  PhotographerReivewCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

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
            make.leading.equalToSuperview().offset(trinapOffset * 2)
            make.top.equalToSuperview().offset(trinapOffset * 3)
            make.width.height.equalTo(trinapOffset * 5)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(trinapOffset)
            make.top.equalTo(profileImageView.snp.top)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(trinapOffset)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        ratingView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.centerY.equalTo(profileImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.leading)
            make.trailing.equalTo(ratingView.snp.trailing)
            make.top.equalTo(profileImageView.snp.bottom).offset(trinapOffset * 2)
            make.bottom.equalToSuperview().inset(trinapOffset * 3)
        }
    }

    override func configureAttributes() {
        self.isUserInteractionEnabled = false
    }
    
    func configure(with review: UserReview) {
        self.nicknameLabel.text = review.user.nickname
        self.dateLabel.text = review.createdAt.toString(type: .yearAndMonthAndDate)
        self.contentLabel.text = review.contents
//        let newSize = self.contentLabel.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newSize = contentLabel.intrinsicContentSize
        self.contentLabel.frame.size = newSize
//        self.contentLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
//        self.contentLabel.invalidateIntrinsicContentSize()
        self.ratingView.configureRating(review.rating)
        self.profileImageView.setImage(at: review.user.profileImage)
    }
}

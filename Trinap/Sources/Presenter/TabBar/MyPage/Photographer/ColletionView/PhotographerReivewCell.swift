//
//  PhotographerReivewCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class PhotographerReivewCell: BaseCollectionViewCell {
    
    private lazy var profileImage = ProfileImageView()
    private lazy var ratingView = RatingView(style: .view)
    
    private lazy var nickNameLabel = UILabel().than {
        $0.text = "어디로든떠나요"
        $0.textColor = .black
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
    
    private lazy var contentsLabel = UILabel().than {
        $0.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In convallis diam lorem felis dignissim amet. Tincidunt porttitor quis faucibus pulvinar pellentesque in rhoncus at diam."
        $0.numberOfLines = 0
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = TrinapAsset.gray40.color
    }
    
    
    override func configureHierarchy() {
        self.addSubviews([
            profileImage, nickNameLabel, contentsLabel, ratingView
        ])
    }
    
    override func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(trinapOffset)
            make.top.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(profileImage)
            make.height.equalTo(trinapOffset * 2)
            make.width.equalTo(trinapOffset * 9)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(profileImage.snp.bottom).offset(trinapOffset * 2)
        }
    }
    
    override func configureAttributes() {
        
    }
    
    func configure(with review: PhotographerReview) {
        self.nickNameLabel.text = review.user.nickname
        self.contentsLabel.text = review.contents
        self.ratingView.configureRating(review.rating)
        self.profileImage.qf.setImage(at: review.user.profileImage)  
    }
}

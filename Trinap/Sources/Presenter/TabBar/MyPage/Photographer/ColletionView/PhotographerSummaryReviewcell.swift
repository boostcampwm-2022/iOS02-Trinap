//
//  PhotographerSummaryReviewcell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class PhotographerSummaryReviewcell: BaseCollectionViewCell {
    private lazy var containerView = UIView().than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.layer.cornerRadius = 8
    }
    
    private lazy var starImageView = UIImageView().than {
        $0.image = UIImage(systemName: "star.fill")
        $0.tintColor = TrinapAsset.secondary.color
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var ratingCountLabel = UILabel().than {
        $0.text = "0"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
    
    private lazy var reviewCountLabel = UILabel().than {
        $0.text = "리뷰 0개"
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    override func configureHierarchy() {
        self.addSubviews([containerView])
        self.containerView.addSubviews([reviewCountLabel, starImageView, ratingCountLabel])
    }
    
    override func configureConstraints() {
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset / 2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(trinapOffset * 3)
        }
        
        ratingCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(starImageView.snp.trailing).offset(trinapOffset * 2)
        }
        reviewCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with review: ReviewSummary) {
        self.ratingCountLabel.text = String(review.rating)
        self.reviewCountLabel.text = "리뷰 \(review.count)개"
    }
}

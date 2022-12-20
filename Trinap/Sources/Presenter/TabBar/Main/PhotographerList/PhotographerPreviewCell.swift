//
//  PhotographerPreviewCell.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import Than
import SkeletonView

final class PhotographerPreviewCell: BaseCollectionViewCell {
    
    // MARK: UI
    //    private lazy var thumbnailImageView = ThumbnailImageView()
    private lazy var thumbnailImageView = ThumbnailCollectionView().than {
        $0.skeletonCornerRadius = 20
        $0.isSkeletonable = true
    }
    
    private lazy var locationLabel = UILabel().than {
        $0.text = "XXXXXXXXXXXX"
        $0.isSkeletonable = true
        $0.textColor = TrinapAsset.gray40.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private lazy var nicknameLabel = UILabel().than {
        $0.text = "XXXXXXXXXXXXX"
        $0.isSkeletonable = true
        $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 16)
    }
    
    private lazy var ratingLabel = StarView().than {
        $0.isSkeletonable = true
    }
    
    // MARK: Properties
    var thumbnailCollectionViewDidTap: ControlEvent<IndexPath> {
        return thumbnailImageView.thumbnailDidTap
    }
    
    // MARK: Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nicknameLabel.text = ""
        ratingLabel.configure(rating: 0.0)
        thumbnailImageView.configure(urlStrings: [])
        self.disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        self.isSkeletonable = true
        contentView.isSkeletonable = true
        
        contentView.addSubviews(
            [
                ratingLabel,
                thumbnailImageView,
                locationLabel,
                nicknameLabel
            ]
        )
    }
    
    override func configureConstraints() {
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(trinapOffset)
            make.bottom.equalToSuperview().offset(-60)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset)
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(trinapOffset)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(trinapOffset)
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.height.equalTo(18)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset)
            make.top.equalTo(locationLabel.snp.bottom).offset(trinapOffset * 0.5)
        }
    }
}

extension PhotographerPreviewCell {
    
    func configureCell(_ preview: PhotographerPreview) {
        nicknameLabel.text = "\(preview.name) 작가"
        locationLabel.text = preview.location
        ratingLabel.configure(rating: preview.rating)
        thumbnailImageView.configure(urlStrings: preview.pictures)
    }
}

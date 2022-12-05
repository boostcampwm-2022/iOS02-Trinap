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

final class PhotographerPreviewCell: BaseCollectionViewCell {
    
    // MARK: UI
    // TODO: 이미지 여러개가 겹쳐서 나온다
    private lazy var thumbnailImageView = ThumbnailImageView()
    
    private lazy var locationLabel = UILabel().than {
        $0.textColor = TrinapAsset.gray40.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    private lazy var nicknameLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 16)
    }
    
    private lazy var ratingLabel = StarView()
    
    // MARK: Properties
//    var disposeBag = DisposeBag()
    
    // MARK: Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }

    override func configureHierarchy() {
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
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(trinapOffset)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(locationLabel.snp.centerY)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(locationLabel.snp.bottom).offset(trinapOffset * 0.5)
        }
    }
    
//    func bind(photographerPreview: Driver<PhotographerPreview>) {
//        Logger.print("bind쨔쟈스")
//        photographerPreview
//            .drive { [weak self] preview in
//                guard let self else { return }
//                self.configureCell(preview)
//            }
//            .disposed(by: self.disposeBag)
//    }
}

extension PhotographerPreviewCell {
    
    func configureCell(_ preview: PhotographerPreview) {
        nicknameLabel.text = "\(preview.name) 작가"
        locationLabel.text = preview.location
        ratingLabel.configure(rating: preview.rating)
        thumbnailImageView.configure(imageStrings: preview.pictures)
    }
}

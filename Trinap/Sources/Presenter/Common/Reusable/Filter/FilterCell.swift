//
//  PhotographerTabCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift

final class FilterCell: BaseCollectionViewCell {
        
    private lazy var titleLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.text = "테스트"
    }
    
    override var isSelected: Bool {
        didSet { selectedUpdate() }
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func selectedUpdate() {
        let textColor = self.isSelected ? TrinapAsset.black.color : TrinapAsset.gray40.color
        let font = isSelected ? TrinapFontFamily.Pretendard.bold.font(size: 16) : TrinapFontFamily.Pretendard.regular.font(size: 16)
        
        self.titleLabel.font = font
        self.titleLabel.textColor = textColor
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    func sizeFittingWith(cellHeight: CGFloat, text: String) -> CGSize {
        self.titleLabel.text = text
   
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: cellHeight)

        return self.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
    }
}

//
//  RegisterTagCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class RegisterTagCell: BaseCollectionViewCell {
    
    private lazy var tagLabel = UILabel().than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.subtext2.color
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
    }
    
    override var isSelected: Bool {
        didSet { setSelected() }
    }
    override func configureHierarchy() {
        self.addSubview(tagLabel)
    }
    
    override func configureConstraints() {
        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func configure(tag: TagItem) {
        tagLabel.text = "#\(tag.tag.title)"
    }
    
    private func setSelected() {
        tagLabel.textColor = isSelected ? TrinapAsset.white.color : TrinapAsset.subtext2.color
        tagLabel.backgroundColor = isSelected ? TrinapAsset.primary.color : TrinapAsset.background.color
    }
}

final class TagCollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    
    private let offset: CGFloat
    
    init(offset: CGFloat) {
        self.offset = offset
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = self.offset
        
        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + offset
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

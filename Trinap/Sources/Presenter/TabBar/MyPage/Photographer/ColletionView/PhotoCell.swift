//
//  PhotoCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Queenfisher

final class PhotoCell: BaseCollectionViewCell {
    
    private lazy var imageView = UIImageView().than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.layer.cornerRadius = 8
        $0.image = UIImage(systemName: "plus.circle")
        $0.tintColor = TrinapAsset.white.color
        $0.layer.masksToBounds = true
    }

    private lazy var editButton = UIImageView().than {
        $0.layer.borderColor = TrinapAsset.gray40.color.cgColor
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
        $0.backgroundColor = TrinapAsset.white.color
        $0.tintColor = TrinapAsset.white.color
        $0.contentMode = .scaleAspectFill
        $0.alpha = 0.5
    }
    
    override var isSelected: Bool {
        didSet { setSelected() }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    override func configureHierarchy() {
        self.addSubviews([imageView, editButton])
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(trinapOffset)
            make.width.height.equalTo(trinapOffset * 3)
        }
    }
    
    func configure(picture: Picture?) {
        guard let picture, let url = picture.picture else {
            self.editButton.isHidden = true
            self.isUserInteractionEnabled = false
            return
        }
        
        self.editButton.isHidden = !picture.isEditable
        self.isUserInteractionEnabled = picture.isEditable
        imageView.qf.setImage(at: URL(string: url))
    }
    
    func setSelected() {
        self.editButton.alpha = isSelected ? 1.0 : 0.5
        self.editButton.image = isSelected ? TrinapAsset.selectedMark.image : nil
        self.editButton.layer.borderColor = isSelected ? nil : TrinapAsset.background.color.cgColor
    }
}

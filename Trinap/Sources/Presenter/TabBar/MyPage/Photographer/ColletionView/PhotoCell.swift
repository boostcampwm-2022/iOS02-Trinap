//
//  PhotoCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class PhotoCell: BaseCollectionViewCell {
    
    private lazy var imageView = UIImageView().than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.layer.cornerRadius = 8
        $0.image = UIImage(systemName: "plus.circle")
        $0.tintColor = TrinapAsset.white.color
        $0.layer.masksToBounds = true
    }

    private lazy var editButton = UIView().than {
        $0.layer.borderColor = TrinapAsset.gray40.color.cgColor
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.backgroundColor = TrinapAsset.white.color
        $0.alpha = 0.5
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
        guard let picture else { return }
        self.editButton.isHidden = !picture.isEditable
        imageView.qf.setImage(at: picture.profileImage, placeholder: UIImage(systemName: "plus"))
    }
}

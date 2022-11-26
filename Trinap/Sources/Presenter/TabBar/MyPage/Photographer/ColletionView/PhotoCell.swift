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

    override func configureHierarchy() {
        self.addSubview(imageView)
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(picture: Picture?) {
        guard let picture else { return }
        imageView.qf.setImage(at: picture.profileImage, placeholder: UIImage(systemName: "plus"))
    }
    
    override func bind() {
        
    }
}

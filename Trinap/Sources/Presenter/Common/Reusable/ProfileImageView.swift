//
//  ProfileImageView.swift
//  TrinapTests
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import Kingfisher

final class ProfileImageView: UIImageView {
    
    // MARK: - UI
    
    // MARK: - Properties
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.backgroundColor = TrinapAsset.gray40.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = self.frame.height / 2
        self.layer.cornerRadius = cornerRadius
    }
    
    func setImage(at profileImageURL: URL?) {
        let maxProfileImageSize = CGSize(width: 80, height: 80)
        let downsamplingProcessor = DownsamplingImageProcessor(size: maxProfileImageSize)
        self.kf.setImage(with: profileImageURL, options: [.processor(downsamplingProcessor)])
    }
}

extension Reactive where Base: ProfileImageView {
    var setImage: Binder<URL?> {
        return Binder(self.base) { imageView, url in
            let downsamplingProcessor = DownsamplingImageProcessor(size: imageView.frame.size)
            imageView.kf.setImage(with: url, options: [.processor(downsamplingProcessor)])
        }
    }
}

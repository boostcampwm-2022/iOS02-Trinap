//
//  ThumbnailCollectionViewCell.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/08.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than
import SnapKit
import Kingfisher

final class ThumbnailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: UI
    private lazy var imageView = UIImageView()
    
    // MARK: Properties
    
    // MARK: Initializers
    
    // MARK: Methods
    override func configureHierarchy() {
        self.addSubview(imageView)
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(imageString: String) {
        let width = imageView.frame.width
        let height = imageView.frame.height
        let url = URL(string: imageString)
        Logger.print(imageString)
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIView.placeholder(width: width, height: height)
//            options: [.processor(DownsamplingImageProcessor(size: CGSize(width: width, height: height)))]
        )
        Logger.print(imageView.image)
    }
    
    override func configureAttributes() {}
    override func bind() {}

    override func prepareForReuse() {
        imageView.image = nil
    }
}

// MARK: - Placeholder
private extension UIView {
    
    static func placeholder(width: Double, height: Double) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            TrinapAsset.background.color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        return image
    }
}

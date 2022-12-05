//
//  ThumbnailImageView.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Queenfisher
import Kingfisher

final class ThumbnailImageView: BaseView {
    
    // MARK: UI
    private lazy var thumbnailScrollView = UIScrollView().than {
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isPagingEnabled = true
        $0.clipsToBounds = true
        $0.alwaysBounceHorizontal = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var imageShadowView = UIView().than {
        $0.layer.cornerRadius = 20
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 20
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var thumbnailPageControl = UIPageControl().than {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Properties
    
    // MARK: Initializers
    
    // MARK: Methods
    override func configureHierarchy() {
        self.addSubviews([
            imageShadowView
        ])
        
        imageShadowView.addSubviews([
            thumbnailScrollView,
            thumbnailPageControl
        ])
    }
    
    override func configureConstraints() {
        imageShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbnailScrollView.snp.makeConstraints { make in
            make.edges.equalTo(imageShadowView)
        }
        
        thumbnailPageControl.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnailScrollView.snp.bottom)
            make.centerX.equalTo(thumbnailScrollView)
        }
    }
    
    override func configureAttributes() {
        thumbnailScrollView.delegate = self
    }
}

extension ThumbnailImageView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        thumbnailPageControl.currentPage = Int(round(page))
    }
}

extension ThumbnailImageView {
    
    func configure(imageStrings: [String]) {
        thumbnailPageControl.numberOfPages = imageStrings.count
        configureThumbnailImage(imageStrings)
    }
    
    //TODO: 여기서 오직 꼬이는 중,ㄴㅇㄹ.ㄴㅇ.ㄹㄴ.ㄹㅇㄴ.ㄹ.ㄹ.ㅇㄴ
    private func configureThumbnailImage(_ imageNames: [String]) {
        Logger.printArray(imageNames)
        for (index, name) in imageNames.enumerated() {
//            Logger.print(name)
            guard let url = URL(string: name) else { continue }
            let imageView = UIImageView()
            let imageSize = thumbnailScrollView.frame.size

            imageView.kf.setImage(
                with: url
//                options: [
//                    .processor(DownsamplingImageProcessor(size: imageSize)),
//                    .scaleFactor(UIScreen.main.scale),
//                    .cacheOriginalImage
//                ]
            ) { [weak self] _ in
                guard
                    let width = self?.thumbnailScrollView.frame.width,
                    let y = self?.thumbnailScrollView.frame.minY,
                    let side = self?.thumbnailScrollView.frame.width
                else { return }
                let x = width * CGFloat(index)
                imageView.frame = CGRect(x: x, y: y, width: side, height: side)
                self?.thumbnailScrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
                self?.thumbnailScrollView.addSubview(imageView)
            }
            
        }
    }
}

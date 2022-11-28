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
        $0.addTarget(self, action: #selector(tappedThumbnailPageControl), for: .valueChanged)
    }
    
    // MARK: Properties
    private var timer: Timer?
    
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

        timerInitialize()
    }
}

// MARK: 스크롤 관련
extension ThumbnailImageView {
    
    func timerInitialize() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerThumbnailPageControl),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func tappedThumbnailPageControl(_ sender: UIPageControl) {
        let current = sender.currentPage
        let width = thumbnailScrollView.frame.width
        thumbnailScrollView.setContentOffset(
            CGPoint(x: CGFloat(current) * width, y: 0),
            animated: true
        )
    }
    
    @objc func timerThumbnailPageControl() {
        let numberOfPage = thumbnailPageControl.numberOfPages
        var current = thumbnailPageControl.currentPage
        if current + 1 == numberOfPage {
            current = 0
        } else {
            current += 1
        }
        let width = thumbnailScrollView.frame.width
        thumbnailScrollView.setContentOffset(
            CGPoint(x: CGFloat(current) * width, y: 0),
            animated: true
        )
    }
}

extension ThumbnailImageView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        thumbnailPageControl.currentPage = Int(round(page))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timerInitialize()
    }
}

extension ThumbnailImageView {
    
    func configure(imageStrings: [String]) {
        thumbnailPageControl.numberOfPages = imageStrings.count
        configureThumbnailImage(imageStrings)
    }
    
    private func configureThumbnailImage(_ imageNames: [String]) {
        for (index, name) in imageNames.enumerated() {
            guard let url = URL(string: name) else { continue }
            let imageView = UIImageView()
            let imageSize = thumbnailScrollView.frame.size
            imageView.backgroundColor = .systemPink
            
            imageView.kf.setImage(with: url) { [weak self] _ in
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

private extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

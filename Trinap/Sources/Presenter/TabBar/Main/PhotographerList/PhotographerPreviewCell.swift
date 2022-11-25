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
import Than
import Queenfisher

final class PhotographerPreviewCell: BaseCollectionViewCell {
    
    // MARK: UI
    private lazy var thumbnailScrollView = UIScrollView().than {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isPagingEnabled = true
        $0.alwaysBounceHorizontal = true
    }
    
    private lazy var thumbnailPageControl = UIPageControl().than {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tappedThumbnailPageControl), for: .valueChanged)
    }
    
    private lazy var locationLabel = UILabel().than {
        $0.text = "지역"
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 12)
    }
    
    private lazy var nicknameLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 15)
        $0.text = "닉네임"
    }
    
    private lazy var ratingLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 15)
        $0.text = "별점"
    }
    
    // MARK: Properties
    private let disposebag = DisposeBag()
    private var timer: Timer?
    
    // MARK: Methods
    override func configureHierarchy() {
        contentView.addSubviews(
            [
            thumbnailScrollView,
            thumbnailPageControl,
            locationLabel,
            nicknameLabel,
            ratingLabel
            ]
        )
    }
    
    override func configureConstraints() {
        thumbnailScrollView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(80)
        }
        
        thumbnailPageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(10)
            make.centerX.equalTo(thumbnailScrollView)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(thumbnailScrollView.snp.bottom).offset(5)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(thumbnailScrollView.snp.bottom).offset(5)
        }
    }
    
    func bind(photographerPreview: Driver<PhotographerPreview>) {
        photographerPreview
            .drive { [weak self] preview in
                guard let self else { return }
                self.configureCell(preview)
            }
            .disposed(by: disposebag)
    }
    
    override func configureAttributes() {
        thumbnailScrollView.delegate = self
        timerInitialize()
    }
}

// MARK: 스크롤 관련
extension PhotographerPreviewCell {
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

extension PhotographerPreviewCell: UIScrollViewDelegate {
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

extension PhotographerPreviewCell {
    
    private func configureCell(_ preview: PhotographerPreview) {
        nicknameLabel.text = preview.name
        locationLabel.text = preview.location
        ratingLabel.text = "\(preview.rating)"
        thumbnailPageControl.numberOfPages = preview.pictures.count
        configureThumbnailImage(preview.pictures)
    }
    
    private func configureThumbnailImage(_ imageNames: [String]) {
        for (index, name) in imageNames.enumerated() {
            guard let url = URL(string: name) else { continue }
            let imageView = UIImageView()
            imageView.qf.setImage(at: url) { [weak self] _ in
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

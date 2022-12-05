//
//  RatingView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import Than

final class RatingView: BaseView {
    
    enum RatingStyle {
        case create
        case view
    }
    
    var currentRate = BehaviorSubject<Int>(value: 0)
    private let style: RatingStyle
    
    private var buttons: [UIButton] = []
    
    private lazy var starFillImage: UIImage? = {
        return TrinapAsset.starFillReview.image
    }()
    
    private lazy var starImage: UIImage? = {
        return TrinapAsset.starReview.image
    }()
    
    private lazy var stackView = UIStackView().than {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    init(style: RatingStyle) {
        self.style = style
        
        super.init(frame: .zero)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        let inset = frame.width / 10
        stackView.snp.updateConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(inset)
        }
    }
    
    override func configureHierarchy() {
        
        (1...5).forEach { _ in
            let button = generateStarButton()
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        self.addSubview(stackView)
    }
    
    override func configureConstraints() {
        let inset = frame.width / 10
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(inset)
        }
    }
    
    override func configureAttributes() {
        self.backgroundColor = TrinapAsset.background.color
        self.isUserInteractionEnabled = self.style == .create
    }
    
    override func bind() {
        self.buttons.enumerated().forEach { index, button in
            button.rx.tap
                .map { index + 1 }
                .bind(to: currentRate)
                .disposed(by: disposeBag)
        }
        
        self.currentRate
            .subscribe { [weak self] rate in
                self?.configureRating(rate)
            }
            .disposed(by: disposeBag)
    }
    
    func configureRating(_ rate: Int) {
        
        let starCount = 5
        
        (0..<rate).forEach { i in
            buttons[i].setImage(starFillImage, for: .normal)
        }
        
        (rate..<starCount).forEach { i in
            buttons[i].setImage(starImage, for: .normal)
        }
    }
    
    private func generateStarButton() -> UIButton {
        
        let pointSize: CGFloat = self.style == .create ? 35 : 12
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: pointSize)
        
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.setPreferredSymbolConfiguration(imageConfiguration, forImageIn: .normal)
        button.setImage(starImage, for: .normal)
        button.imageView?.tintColor = TrinapAsset.secondary.color
        button.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        return button
    }
}

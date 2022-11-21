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
    
    private lazy var starImage: UIImage? = {
        return UIImage(systemName: "star.fill")
    }()
    
    private lazy var stackView = UIStackView().than {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
    }
    
    init(style: RatingStyle) {
        self.style = style
        
        super.init(frame: .zero)
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
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
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
                self?.updateRating(rate: rate)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateRating(rate: Int) {
        
        let starCount = 5
        
        (0..<rate).forEach { i in
            buttons[i].imageView?.tintColor = TrinapAsset.secondary.color
        }
        
        (rate..<starCount).forEach { i in
            buttons[i].imageView?.tintColor = .lightGray
        }
    }
    
    private func generateStarButton() -> UIButton {
        
        let pointSize: CGFloat = self.style == .create ? 35 : 12
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: pointSize)
        
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.tintColor = .lightGray
        button.setPreferredSymbolConfiguration(imageConfiguration, forImageIn: .normal)
        button.setImage(starImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        return button
    }
}

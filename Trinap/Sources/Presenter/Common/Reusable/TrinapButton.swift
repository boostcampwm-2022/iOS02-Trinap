//
//  TrinapButton.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

/// 자주 사용되는 버튼에 대한 커스텀 버튼입니다.
final class TrinapButton: UIButton {
    
    // MARK: - Properties
    var cornerRadius: CGFloat {
        get { self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    private var style: ColorType
    private var fillType: FillType
    private var isCircle: Bool
    
    // MARK: - Initializers
    
    /// 버튼의 `style`과 `fill`을 선택할 수 있습니다.
    /// - Parameters:
    ///   - style: Primary, Secondary 등 기본 Color Asset에 등록된 색상으로 버튼을 채웁니다.
    ///   - fill: 색상을 칠하는 방식을 선택합니다.
    ///   - isCircle: `cornerRadius`와 관계 없이 버튼을 원으로 구성합니다.
    init(style: ColorType, fillType: FillType = .fill, isCircle: Bool = false) {
        self.style = style
        self.fillType = fillType
        self.isCircle = isCircle
        
        super.init(frame: .zero)
        
        self.cornerRadius = 8.0
        self.configureColorSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isCircle {
            let cornerRadius = self.frame.height / 2
            self.layer.cornerRadius = cornerRadius
        }
    }
}

// MARK: - Privates
private extension TrinapButton {
    
    typealias ColorSet = (borderColor: UIColor, fillColor: UIColor, textColor: UIColor)
    
    var colorSet: ColorSet {
        switch self.fillType {
        case .fill:
            return (self.style.color, self.style.color, TrinapAsset.white.color)
        case .border:
            return (self.style.color, TrinapAsset.white.color, self.style.color)
        }
    }
    
    func configureColorSet() {
        let colorSet = self.colorSet
        
        self.clipsToBounds = true
        self.layer.borderColor = colorSet.borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = colorSet.fillColor
        self.setTitleColor(colorSet.textColor, for: .normal)
    }
}

// MARK: - TrinapButton.ColorType
extension TrinapButton {
    
    enum ColorType {
        case primary
        case secondary
        case error
        case black
        
        var color: UIColor {
            switch self {
            case .primary:
                return TrinapAsset.primary.color
            case .secondary:
                return TrinapAsset.secondary.color
            case .error:
                return TrinapAsset.error.color
            case .black:
                return TrinapAsset.black.color
            }
        }
    }
}

// MARK: - TrinapButton.FillType
extension TrinapButton {
    
    enum FillType {
        case fill
        case border
    }
}

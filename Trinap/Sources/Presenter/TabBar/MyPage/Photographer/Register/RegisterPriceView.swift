//
//  RegisterPriceView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift

final class RegisterPriceView: BaseView {
    
    lazy var textField = UITextField().than {
        $0.keyboardType = .numberPad
        $0.backgroundColor = TrinapAsset.white.color
        $0.textAlignment = .left
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.black.color
        $0.placeholder = "가격을 책정해주세요"
    }
    
    private lazy var unitLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.black.color
        $0.text = "원"
        $0.sizeToFit()
    }
    
    override func configureHierarchy() {
        self.addSubviews([textField, unitLabel])
    }
    
    override func configureConstraints() {
        unitLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(trinapOffset * 2)
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(unitLabel.snp.leading).offset(-(trinapOffset * 2))
        }
    }
    
    override func configureAttributes() {
        self.layer.borderWidth = 1
        self.layer.borderColor = TrinapAsset.background.color.cgColor
        self.layer.cornerRadius = 8
    }
}

extension Reactive where Base: RegisterPriceView {
    var setValue: Binder<Int> {
        return Binder(self.base) { registerPriceView, price in
            registerPriceView.textField.text = String(price)
        }
    }
}

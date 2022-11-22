//
//  NicknameTextFieldView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/20.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Than

final class NicknameTextFieldView: BaseView {
    
    // MARK: - UI
    lazy var textField = UITextField().than {
        $0.placeholder = "띄어쓰기 포함 8자 이내"
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    lazy var generateButton = UIButton().than {
        $0.setTitle("자동생성", for: .normal)
        $0.setTitleColor(TrinapAsset.primary.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        textField.delegate = self
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        [textField, generateButton].forEach { self.addSubview($0) }
    }
    
    override func configureConstraints() {
        self.generateButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        self.textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(generateButton.snp.leading)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = TrinapAsset.disabled.color.cgColor
    }
}

// MARK: - UITextFieldDelegate
extension NicknameTextFieldView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.layer.borderColor = TrinapAsset.black.color.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.layer.borderColor = TrinapAsset.disabled.color.cgColor
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let maxLength = 8

        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게 작동
        if text.count >= maxLength && range.length == 0 && range.location >= maxLength {
            textField.endEditing(true
            )
            return false
        }
        
        return true
    }
    
    // TODO: - 외부에서 복사한 텍스트에 대한 길이 제한 기능 추가
}

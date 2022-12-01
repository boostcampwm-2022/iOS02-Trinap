//
//  ReservationButtonView.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class ReservationButtonView: BaseView {
    
    // MARK: - UI
    private lazy var buttonStackView = UIStackView().than {
        $0.distribution = .fillEqually
        $0.spacing = 8.0
    }
    
    private lazy var primaryButton = TrinapButton(style: .black)
    private lazy var secondaryButton = TrinapButton(style: .disabled)
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(secondaryButton)
        buttonStackView.addArrangedSubview(primaryButton)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.addBorder([.top])
    }
    
    func setPrimaryContent(title: String, fillType: TrinapButton.FillType, style: TrinapButton.ColorType) {
        primaryButton.fill = fillType
        primaryButton.style = style
        primaryButton.setTitle(title, for: .normal)
    }
    
    func setSecondaryContent(title: String, fillType: TrinapButton.FillType, style: TrinapButton.ColorType) {
        secondaryButton.fill = fillType
        secondaryButton.style = style
        secondaryButton.setTitle(title, for: .normal)
    }
}

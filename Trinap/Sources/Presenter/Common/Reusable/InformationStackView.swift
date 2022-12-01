//
//  InformationStackView.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/30.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class InformationStackView: BaseView {
    
    enum Alignment {
        case leading
        case trailing
        
        var nsTextAlignment: NSTextAlignment {
            switch self {
            case .leading:
                return .left
            case .trailing:
                return .right
            }
        }
    }
    
    // MARK: - Properties
    private lazy var tableStackView = UIStackView().than {
        $0.axis = .horizontal
        $0.spacing = 16.0
    }
    
    private lazy var keyStackView = UIStackView().than {
        $0.axis = .vertical
        $0.spacing = 8.0
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private lazy var valueStackView = UIStackView().than {
        $0.axis = .vertical
        $0.spacing = 8.0
    }
    
    private let descriptionAlignment: Alignment
    
    // MARK: - Initializers
    init(descriptionAlignment: Alignment) {
        self.descriptionAlignment = descriptionAlignment
        
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 8.0
        self.backgroundColor = TrinapAsset.background.color
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(tableStackView)
        self.tableStackView.addArrangedSubview(keyStackView)
        self.tableStackView.addArrangedSubview(valueStackView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        tableStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configureInformations(_ informations: [Information]) {
        informations.forEach { information in
            self.addInformation(information)
        }
    }
}

// MARK: - Privates
private extension InformationStackView {
    
    func addInformation(_ information: Information) {
        addKeyLabel(with: information.key)
        addValueLabel(with: information.value)
    }
    
    func addKeyLabel(with key: String) {
        let keyLabel = keyLabel(key)
        
        keyStackView.addArrangedSubview(keyLabel)
    }
    
    func keyLabel(_ key: String) -> UILabel {
        return UILabel().than {
            $0.text = key
            $0.textColor = TrinapAsset.black.color
            $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 16)
        }
    }
    
    func addValueLabel(with value: String) {
        let valueLabel = valueLabel(value)
        
        valueStackView.addArrangedSubview(valueLabel)
    }
    
    func valueLabel(_ value: String) -> UILabel {
        return UILabel().than {
            $0.text = value
            $0.textColor = TrinapAsset.black.color
            $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
            $0.textAlignment = self.descriptionAlignment.nsTextAlignment
        }
    }
}

// MARK: - Information Model
struct Information {
    
    let key: String
    let value: String
}

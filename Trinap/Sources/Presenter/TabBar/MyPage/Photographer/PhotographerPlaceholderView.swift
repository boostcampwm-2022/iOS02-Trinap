//
//  PhotographerPlaceholderView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class PhotographerPlaceholderView: BaseView {
    
    var type: ViewType = .portfolio {
        didSet { configure() }
    }

    private let isEditable: Bool
    
    private lazy var titleLabel = UILabel().than {
        $0.textAlignment = .center
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    private lazy var subTitleLabel = UILabel().than {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = TrinapAsset.subtext2.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    lazy var applyButton = TrinapButton(style: .primary, fillType: .border).than {
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 14)
    }
    
    init(isEditable: Bool) {
        self.isEditable = isEditable
        
        super.init(frame: .zero)
        
        configureAttributes()
        configureHierarchy()
        configureConstraints()
    }
    
    private func configure() {
        self.titleLabel.text = type.title
        
        guard let subTitle = type.subtitle, let buttonTitle = type.buttonTitle else {
            updateLayout(isHidden: true)
            return
        }
        
        updateLayout(isHidden: false)
        self.subTitleLabel.text = subTitle
        self.applyButton.setTitle(buttonTitle, for: .normal)
    }
    
    override func configureHierarchy() {
        self.addSubviews([titleLabel, subTitleLabel, applyButton])
    }
    
    override func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(trinapOffset)
        }
        
        if isEditable {
            self.applyButton.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(trinapOffset * 11)
                make.top.equalTo(subTitleLabel.snp.bottom).offset(trinapOffset)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func updateLayout(isHidden: Bool) {
        self.subTitleLabel.isHidden = isHidden
        self.applyButton.isHidden = isHidden
    }
    
    override func configureAttributes() {
        self.backgroundColor = .clear
        self.configure()
    }
}

// MARK: - Type
extension PhotographerPlaceholderView {
    
    enum ViewType: Int, CaseIterable {
        case portfolio = 0
        case detail
        case reveiw
        
        var title: String {
            switch self {
            case .portfolio:
                return "아직 등록된 포트폴리오가 없습니다."
            case .detail:
                return "아직 등록된 상세정보가 없습니다."
            case .reveiw:
                return "아직 등록된 리뷰가 없습니다."
            }
        }
        
        var subtitle: String? {
            switch self {
            case .portfolio:
                return "포트폴리오를 등록하고\n다양한 고객님을 만나보세요"
            case .detail:
                return "상세정보를 등록하고\n작가님의 능력을 어필해보세요!"
            default:
                return nil
            }
        }
        
        var buttonTitle: String? {
            switch self {
            case .portfolio:
                return "포트폴리오 등록하기"
            case .detail:
                return "상세정보 등록하기"
            case .reveiw:
                return nil
            }
        }
    }
}

extension Reactive where Base: PhotographerPlaceholderView {
    
    var setState: Binder<Int> {
        Binder(self.base) { defaultView, type in
            guard let type = PhotographerPlaceholderView.ViewType.init(rawValue: type) else {
                return
            }
            defaultView.type = type
        }
    }
}

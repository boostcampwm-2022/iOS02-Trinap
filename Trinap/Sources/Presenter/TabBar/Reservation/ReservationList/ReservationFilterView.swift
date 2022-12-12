//
//  ReservationFilterView.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

final class ReservationFilterView: BaseView {
    
    // MARK: - UI
    lazy var searchControl = UnderlinedSegmentedControl(items: ["받은 예약", "보낸 예약"]).than {
        $0.setTitleTextAttributes(
            [.foregroundColor: TrinapAsset.subtext2.color, .font: TrinapFontFamily.Pretendard.bold.font(size: 20)],
            for: .normal
        )
        $0.setTitleTextAttributes(
            [.foregroundColor: TrinapAsset.black.color, .font: TrinapFontFamily.Pretendard.bold.font(size: 20)],
            for: .selected
        )
        $0.selectedSegmentIndex = 0
    }
    
    // MARK: - Properties
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    var selectedSegmentIndex: Int {
        return searchControl.selectedSegmentIndex
    }
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(searchControl)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        searchControl.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Reactive Extension
extension Reactive where Base: ReservationFilterView {
    
    var selectedSegmentIndex: ControlProperty<Int> {
        return base.searchControl.rx.selectedSegmentIndex
    }
}

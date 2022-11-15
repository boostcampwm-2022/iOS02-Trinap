//
//  BaseView.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import RxSwift

class BaseView: UIView {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureHierarchy()
        configureConstraints()
        bind()
    }
    
    func configureHierarchy() {}
    func configureConstraints() {}
    func configureAttributes() {}
    func bind() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is called.")
    }
}

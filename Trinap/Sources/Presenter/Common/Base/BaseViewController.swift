//
//  BaseViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TrinapAsset.background.color
        
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
    required init(coder: NSCoder) {
        fatalError("init(coder:) is called.")
    }
}

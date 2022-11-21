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
    var disposeBag = DisposeBag()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TrinapAsset.white.color
        
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
}

//
//  BaseViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var indicator: UIActivityIndicatorView?
    
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

// MARK: - Indicator
extension BaseViewController {
    
    func showFullSizeIndicator() {
        let indicator = createIndicator()
        self.indicator = indicator
        
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        indicator.startAnimating()
    }
    
    func hideFullSizeIndicator() {
        self.indicator?.stopAnimating()
        self.indicator?.removeFromSuperview()
        self.indicator = nil
    }
    
    private func createIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.backgroundColor = TrinapAsset.black.color.withAlphaComponent(0.7)
        indicator.color = TrinapAsset.white.color
        indicator.layer.cornerRadius = 20
        return indicator
    }
}

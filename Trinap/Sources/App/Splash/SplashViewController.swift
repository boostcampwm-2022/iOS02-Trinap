//
//  SplashViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TrinapAsset.logoVertical.image
        return imageView
    }()
    
    // MARK: - Properties
    private let viewModel: SplashViewModel
    
    // MARK: - Properties
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.autoSignInFlow()
    }
    
    override func configureHierarchy() {
        view.addSubview(logoImageView)
    }
    
    override func configureConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.equalTo(140)
            make.horizontalEdges.equalToSuperview().inset(50)
        }
    }
}

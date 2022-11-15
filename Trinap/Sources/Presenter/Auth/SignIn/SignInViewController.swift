//
//  SignInViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import SnapKit

final class SignInViewController: BaseViewController {
    private var appleSignInButton: UIButton = {
        let button = UIButton()
        button.setTitle("애플로 로그인 하기", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
    
    override func configureHierarchy() {
        [appleSignInButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        appleSignInButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        
    }
}

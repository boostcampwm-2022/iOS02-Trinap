//
//  SignInViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import AuthenticationServices
import UIKit

import SnapKit

final class SignInViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TrinapAsset.logoVertical.image
        return imageView
    }()
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [logoImageView, appleSignInButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(50)
        }
        
        appleSignInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(48)
            make.top.equalTo(logoImageView.snp.centerY).multipliedBy(1.9)
        }
    }
    
//    override func configureAttributes() { }
}
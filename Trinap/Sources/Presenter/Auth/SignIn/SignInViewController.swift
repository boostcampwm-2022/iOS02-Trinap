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
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TrinapAsset.logoVertical.image
        return imageView
    }()
    
    private var appleSignInButton: ASAuthorizationAppleIDButton = {
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
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(50)
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(48)
            $0.top.equalTo(logoImageView.snp.centerY).multipliedBy(1.9)
        }
    }
    
//    override func configureAttributes() { }
}

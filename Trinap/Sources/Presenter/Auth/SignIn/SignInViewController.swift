//
//  SignInViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import AuthenticationServices
import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Than

final class SignInViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TrinapAsset.logoVertical.image
        return imageView
    }()
    
    private lazy var appleSignInButton = TrinapButton(style: .black).than {
        $0.setImage(TrinapAsset.logoApple.image, for: .normal)
        $0.setTitle("Apple로 시작하기", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 14)
    }
    
    private lazy var privacyPolicyButton = UIButton().than {
        $0.setTitle("개인정보처리방침", for: .normal)
        $0.setTitleColor(TrinapAsset.subtext2.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.regular.font(size: 12)
    }
    
    // MARK: - Properties
    private let viewModel: SignInViewModel
    
    // MARK: - Initializers
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            logoImageView,
            appleSignInButton,
            privacyPolicyButton
        ])
    }
    
    override func configureConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.equalTo(140)
            make.horizontalEdges.equalToSuperview().inset(50)
        }
        
        appleSignInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(48)
            make.top.equalTo(logoImageView.snp.centerY).multipliedBy(1.9)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(appleSignInButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    override func bind() {
        let credential = appleSignInButton.rx.tap
            .asObservable()
            .flatMap {
                ASAuthorizationAppleIDProvider().rx.login(scope: [.email])
            }
            .withUnretained(self)
            .compactMap { owner, authorization in
                return owner.generateOAuthCredential(authorization: authorization)
            }
        
        let input = SignInViewModel.Input(
            credential: credential
        )
        let output = viewModel.transform(input: input)
        
        privacyPolicyButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.openPrivacyPolicy()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - private Function
private extension SignInViewController {
    
    private func generateOAuthCredential(authorization: ASAuthorization) -> (OAuthCredential, String)? {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let nonce = generateRandomNonce().toSha256()
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                Logger.print("Unable to fetch identity token")
                return nil
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                Logger.print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return nil
            }
            
            guard
                let authorizationCode = appleIDCredential.authorizationCode,
                let codeString = String(data: authorizationCode, encoding: .utf8)
            else {
                Logger.print("Unable to serialize token string from authorizationCode")
                return nil
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            return (credential, codeString)
        }
        return nil
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func generateRandomNonce(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

// MARK: - Privacy Policy
private extension SignInViewController {
    
    func openPrivacyPolicy() {
        guard let url = Private.privacyPolicyURL else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

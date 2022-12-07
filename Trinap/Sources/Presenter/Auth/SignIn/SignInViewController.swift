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
    
    // MARK: - Properties
    private var currentNonce: String?
    private let viewModel: SignInViewModel
    private let credentialSub = PublishSubject<(OAuthCredential, String)>()
    
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
        
    override func bind() {
        let input = SignInViewModel.Input(
            signInButtonTap: appleSignInButton.rx.tap.asObservable(),
            credential: credentialSub.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        
        output.presentSignInWithApple
            .asObservable()
            .subscribe { _ in
                self.startSignInWithAppleFlow()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                Logger.print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                Logger.print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            guard let authorizationCode = appleIDCredential.authorizationCode,
                  let codeString = String(data: authorizationCode, encoding: .utf8)
            else {
                Logger.print("Unable to serialize token string from authorizationCode")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            credentialSub.onNext((credential, codeString))
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}

// MARK: - private Function
private extension SignInViewController {
    func startSignInWithAppleFlow() {
        let (request, nonce) = createRequest()
        self.currentNonce = nonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func createRequest() -> (ASAuthorizationAppleIDRequest, String) {
        let nonce = self.generateRandomNonce()
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.toSha256()
        
        return (request, nonce)
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

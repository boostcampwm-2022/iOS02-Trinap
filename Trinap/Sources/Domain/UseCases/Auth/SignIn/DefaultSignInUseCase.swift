//
//  DefaultSignInUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirebaseAuth
import RxSwift

final class DefaultSignInUseCase: SignInUseCase {
    
    // MARK: - Properties
    private let authRepository: AuthRepository
    
    // MARK: - Initializers
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // MARK: - Methods
    func signIn(with credential: (OAuthCredential, String)) -> Observable<SignInResult> {
        let (credential, authorizationCode) = credential
        return Observable.zip(
            self.authRepository.fetchRefreshToken(with: authorizationCode),
            self.authRepository.signIn(with: credential)
                .asObservable()
        )
        .withUnretained(self)
        .flatMap { owner, _ in
            return owner.authRepository.checkUser()
                .map { $0 ? SignInResult.signIn : SignInResult.signUp }
        }
        .asObservable()
        .catchAndReturn(SignInResult.failure)
    }
    
    func autoSignIn() -> Observable<Bool> {
        if Auth.auth().currentUser != nil {
            return self.authRepository.checkUser()
                .asObservable()
                .catchAndReturn(false)
        } else {
            return Observable.just(false)
        }
    }
    
    func updateFcmToken() -> Observable<Void> {
        return authRepository.updateFcmToken()
    }
}

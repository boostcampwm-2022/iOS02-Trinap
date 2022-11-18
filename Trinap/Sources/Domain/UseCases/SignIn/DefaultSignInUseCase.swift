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
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // enum으로 반환타입 수정
    func signIn(with credential: OAuthCredential) -> Observable<SignInResult> {
        return self.authRepository.signIn(with: credential)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.authRepository.checkUser()
                    .map { $0 ? SignInResult.signIn : SignInResult.signUp }
            }
            .asObservable()
            .catchAndReturn(SignInResult.failure)
    }
}

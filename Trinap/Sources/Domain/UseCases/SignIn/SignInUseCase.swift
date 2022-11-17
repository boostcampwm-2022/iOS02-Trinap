//
//  SignInUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift
import FirebaseAuth

protocol SignInUseCase {
    
    // MARK: - Methods
    func signIn(with credential: OAuthCredential) -> Observable<SignInResult>
}

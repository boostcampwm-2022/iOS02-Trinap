//
//  AuthRepository.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirebaseAuth
import RxSwift


protocol AuthRepository {
    
    // MARK: - Methods
    func checkUser() -> Observable<Void>
    func createUser(with fcmToken: String) -> Observable<Void>
    func signIn(with cretencial: OAuthCredential) -> Observable<String>
    func signOut() -> Observable<Void>
    func dropOut() -> Observable<Void>
}

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
    func checkUser() -> Single<Bool>
    func createUser(nickname: String) -> Observable<Void>
    func updateFcmToken() -> Observable<Void>
    func deleteFcmToken() -> Observable<Void>
    func signIn(with cretencial: OAuthCredential) -> Single<String>
    func signOut() -> Single<Void>
    func dropOut() -> Single<Void>
    func removeUserInfo(photographerId: String) -> Single<Void>
}

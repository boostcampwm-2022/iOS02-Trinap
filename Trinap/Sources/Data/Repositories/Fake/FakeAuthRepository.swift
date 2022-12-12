//
//  FakeAuthRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirebaseAuth
import RxSwift

struct FakeAuthRepository: AuthRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    
    // MARK: - Initializers
    init(isSucceedCase: Bool) {
        self.isSucceedCase = isSucceedCase
    }
    
    // MARK: - Methods
    func checkUser() -> Single<Bool> {
        return execute(successValue: isSucceedCase).asSingle()
    }
    
    func createUser(nickname: String) -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func updateFcmToken() -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func deleteFcmToken() -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func signIn(with cretencial: OAuthCredential) -> Single<String> {
        return execute(successValue: #function).asSingle()
    }
    
    func signOut() -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
    
    func dropOut() -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
    
    func removeUserInfo(photographerId: String) -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
    
    func fetchRefreshToken(with authorizationCode: String) -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func revokeToken() -> Observable<Void> {
        return execute(successValue: ())
    }
}

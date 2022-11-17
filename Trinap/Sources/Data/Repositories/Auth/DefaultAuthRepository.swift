//
//  DefaultAuthRepository.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirebaseAuth
import FirestoreService
import RxSwift

final class DefaultAuthRepository: AuthRepository {
    
    // MARK: - Properties
    private let firebaseStoreService: FireStoreService
    private let tokenManager: TokenManager
    
    // MARK: - Methods
    init(
        firebaseStoreService: FireStoreService = DefaultFireStoreService(),
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.firebaseStoreService = firebaseStoreService
        self.tokenManager = tokenManager
    }
    
//    func checkUser() -> RxSwift.Observable<Void> {
//
//    }
//
//    func createUser(with fcmToken: String) -> RxSwift.Observable<Void> {
//        <#code#>
//    }
    
    func signIn(with cretencial: OAuthCredential) -> RxSwift.Single<String> {
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            Auth.auth().signIn(with: cretencial){ authResult, error in //
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let userId = authResult?.user.uid else {
                    // TODO: 인증 관련 에러를 구현하여 교체
                    single(.failure(FireStoreError.unknown))
                    return
                }
                
                single(.success(userId))
            }
            return Disposables.create()
        }
    }
    
//    func signOut() -> RxSwift.Observable<Void> {
//        <#code#>
//    }
//
//    func dropOut() -> RxSwift.Observable<Void> {
//        <#code#>
//    }
    
    
}

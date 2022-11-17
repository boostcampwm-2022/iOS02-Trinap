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
    func createUser(nickname: String, fcmToken: String) -> Observable<Void> {
        guard let userId = tokenManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        let user = UserDTO(
            userId: userId,
            nickname: nickname,
            // TODO: nil or 빈 문자열?
            profileImage: "",
            isPhotographer: false,
            fcmToken: fcmToken,
            status: .activate
        )
        
        guard let values = user.asDictionary else {
            return .error(FireStoreError.unknown)
        }
        
        return firebaseStoreService.createDocument(
            collection: .users,
            document: user.userId,
            values: values
        )
        .asObservable()
    }
    
    func signIn(with cretencial: OAuthCredential) -> Single<String> {
        return Single.create { single in
                        
            Auth.auth().signIn(with: cretencial) { authResult, error in
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
    
//    func signOut() -> Single<Void> {
//        return Single.create { single in
//                    
//            do {
//                try Auth.auth().signOut()
//                // TODO: 로그아웃 성공시 이렇게 처리하는게 맞을까요..?
//                single(.success(()))
//            } catch let error {
//                single(.failure(error))
//                return
//            }
//            return Disposables.create()
//        }
//    }
//
//    func dropOut() -> RxSwift.Observable<Void> {
//        <#code#>
//    }
    
    
}

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
    
    // MARK: Initializer
    init(
        firebaseStoreService: FireStoreService = DefaultFireStoreService(),
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.firebaseStoreService = firebaseStoreService
        self.tokenManager = tokenManager
    }
    
    // MARK: - Methods
    func checkUser() -> Single<Bool> {
        guard let userId = tokenManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firebaseStoreService.getDocument(
            collection: "users",
            field: "userId",
            in: [userId]
        )
        .map { !$0.isEmpty }
    }

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
        
        return self.firebaseStoreService.createDocument(
            collection: .users,
            document: user.userId,
            values: values
        )
        .asObservable()
    }
    
    func signIn(with cretencial: OAuthCredential) -> Single<String> {
        return Single.create { single in
                        
            Auth.auth().signIn(with: cretencial) { [weak self] authResult, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let userId = authResult?.user.uid else {
                    // TODO: 인증 관련 에러를 구현하여 교체
                    single(.failure(LocalError.signInError))
                    return
                }
                self?.tokenManager.save(token: userId)
                single(.success(userId))
            }
            return Disposables.create()
        }
    }
    
    func signOut() -> Single<Void> {
        return Single.create { single in

            do {
                try Auth.auth().signOut()
                single(.success(()))
            } catch let error {
                single(.failure(error))
                return Disposables.create()
            }
            return Disposables.create()
        }
    }

    func dropOut() -> Single<Void> {
        guard let user = Auth.auth().currentUser else {
            return .error(FireStoreError.unknown)
        }
        
        return Single.create { single in
            user.delete { error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                single(.success(()))
            }
            
            return Disposables.create()
        }
    }
}

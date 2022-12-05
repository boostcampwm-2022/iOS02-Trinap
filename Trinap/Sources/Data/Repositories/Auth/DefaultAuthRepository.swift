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

import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

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
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firebaseStoreService.getDocument(
            collection: .users,
            field: "userId",
            in: [userId]
        )
        .map { !$0.isEmpty }
    }
    
    func createUser(nickname: String) -> Observable<Void> {
        guard
            let userId = tokenManager.getToken(with: .userId),
            let fcmToken = tokenManager.getToken(with: .fcmToken)
        else {
            return .error(TokenManagerError.notFound)
        }
        let user = UserDTO(
            userId: userId,
            nickname: nickname,
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
    
    func updateFcmToken() -> Observable<Void> {
        guard
            let userId = tokenManager.getToken(with: .userId),
            let fcmToken = tokenManager.getToken(with: .fcmToken)
        else {
            return .error(TokenManagerError.notFound)
        }
        
        let values = ["fcmToken": fcmToken]
        
        return firebaseStoreService.updateDocument(
            collection: .users,
            document: userId,
            values: values
        )
        .asObservable()
    }
    
    func deleteFcmToken() -> Observable<Void> {
        guard
            let userId = tokenManager.getToken(with: .userId)
        else {
            return .error(TokenManagerError.notFound)
        }
        
        let values = ["fcmToken": ""]
        
        return firebaseStoreService.updateDocument(
            collection: .users,
            document: userId,
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
                    single(.failure(LocalError.signInError))
                    return
                }
                self?.tokenManager.save(token: userId, with: .userId)
                single(.success(userId))
            }
            return Disposables.create()
        }
    }
    
    func signOut() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            do {
                try Auth.auth().signOut()
                self.tokenManager.deleteToken(with: .userId)
                self.tokenManager.deleteToken(with: .fcmToken)
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
        
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            user.delete { error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                if self.tokenManager.deleteToken(with: .userId),
                   self.tokenManager.deleteToken(with: .fcmToken) {
                    single(.success(()))
                } else {
                    single(.failure(FireStoreError.unknown))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func removeUserInfo(photographerId: String) -> Single<Void> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firebaseStoreService.deleteDocuments(
            collections: [
                (.users, userId),
                (.photographers, photographerId)
            ]
        )
    }
}

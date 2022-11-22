//
//  DefaultUserRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultUserRepository: UserRepository {
    
    // MARK: - Properties
    private let firestoreService: FireStoreService
    private let tokenManager: TokenManager
    private let networkService: NetworkService
    
    // MARK: - Methods
    init(
        tokenManager: TokenManager = KeychainTokenManager(),
        firestoreService: DefaultFireStoreService = DefaultFireStoreService(),
        networkService: DefaultNetworkService = DefaultNetworkService()
    ) {
        self.firestoreService = firestoreService
        self.networkService = networkService
        self.tokenManager = tokenManager
    }
    
    func fetch() -> Observable<User> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.fetch(userId: userId)
    }
    
    func fetch(userId: String) -> Observable<User> {
        return self.firestoreService
            .getDocument(collection: .users, document: userId)
            .compactMap { $0.toObject(UserDTO.self)?.toModel() }
            .asObservable()
    }
    
    func fetchUsers(userIds: [String]) -> Observable<[User]> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let userIds = userIds.filter { $0 != userId }
        
        return self.firestoreService
            .getDocument(collection: .users, field: "userId", in: userIds)
            .map { $0.compactMap { $0.toObject(UserDTO.self)?.toModel() } }
            .asObservable()
    }
    
    func update(profileImage: URL?, nickname: String?, isPhotographer: Bool?) -> Observable<Void> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        var values: [String: Any] = [:]
        
        if let profileImage {
            values.updateValue(profileImage, forKey: "profileImage")
        }
        
        if let nickname {
            values.updateValue(nickname, forKey: "nickname")
        }
        
        if let isPhotographer {
            values.updateValue(isPhotographer, forKey: "isPhotographer")
        }
        
        return self.firestoreService
            .updateDocument(collection: .users, document: userId, values: values)
            .asObservable()
    }
    
    func createRandomNickname() -> Observable<String> {
        let endpoint = RandomNicknameEndpoint.main
        return self.networkService.request(endpoint)
            .decode(type: NicknameDTO.self, decoder: JSONDecoder())
            .compactMap { $0.words.first }
    }
}

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
        firestoreService: FireStoreService = DefaultFireStoreService(),
        networkService: NetworkService = DefaultNetworkService()
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
    
    func fetchUsersWithMine(userIds: [String]) -> Observable<[User]> {
        return self.firestoreService
            .getDocument(collection: .users, field: "userId", in: userIds)
            .map { $0.compactMap { $0.toObject(UserDTO.self)?.toModel() } }
            .asObservable()
    }
    
    func update(profileImage: String?, nickname: String?, isPhotographer: Bool?) -> Observable<Void> {
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
    
    func fetchContact() -> Observable<[Contact]> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        return self.firestoreService.getDocument(collection: .contact, field: "userId", in: [userId])
            .map { $0.compactMap { $0.toObject(ContactDTO.self)?.toModel() } }
            .asObservable()
    }
    
    func fetchDetailContact(contactId: String) -> Observable<Contact> {
        return self.firestoreService.getDocument(
            collection: .contact,
            document: contactId)
        .compactMap { $0.toObject(ContactDTO.self)?.toModel() }
        .asObservable()
    }
    
    func createContact(title: String, contents: String) -> Observable<Void> {
        
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let contactId = UUID().uuidString
        
        let dto = ContactDTO(
            contactId: contactId,
            userId: userId,
            title: title,
            description: contents,
            createAt: Date().toString(type: .timeStamp),
            status: .activate)
        
        guard let values = dto.asDictionary else {
            return .error(LocalError.structToDictionaryError)
        }
        
        return self.firestoreService.createDocument(collection: .contact, document: contactId, values: values)
            .asObservable()
    }
    
    func updatePhotographerExposure(value: Bool) -> Observable<Void> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let value = ["isPhotographer": value]
        
        return firestoreService.updateDocument(
            collection: .users,
            document: userId,
            values: value
        )
        .asObservable()
    }
}

//
//  DefaultSueRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultSueRepository: SueRepository {
    
    // MARK: Properties
    let fireStoreService: FireStoreService
    let keychainManager: TokenManager

    // MARK: Initializers
    init(
        fireStoreService: FireStoreService,
        keychainManager: TokenManager
    ) {
        self.fireStoreService = fireStoreService
        self.keychainManager = keychainManager
    }
    
    // MARK: Methods
    func sueUser(suedUserId: String, contents: String) -> Single<Void> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let dto = SueDTO(
            sueId: UUID().uuidString,
            suedUserId: suedUserId,
            suingUserId: userId,
            contents: contents
        )
        
        guard let values = dto.asDictionary else { return Single.just(())}
        
        return fireStoreService.createDocument(collection: .sue, document: dto.sueId, values: values)
    }
    
    func fetchSuedUsers() -> Single<[Sue]> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStoreService.getDocument(collection: .sue, field: "suingUserId", in: [userId])
            .map { data -> [Sue] in
                data.compactMap { $0.toObject(SueDTO.self)?.toModel() }
            }
    }
}

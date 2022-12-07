//
//  DefaultBlockRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultBlockRepository: BlockRepository {
    
    // MARK: Properties
    let firebase: FireStoreService
    let keychainManager: TokenManager

    // MARK: Initializers
    init(
        fireStoreService: FireStoreService,
        keychainManager: TokenManager
    ) {
        self.firebase = fireStoreService
        self.keychainManager = keychainManager
    }
    
    // MARK: Methods
    func blockUser(blockedUserId: String) -> Single<Void> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }

        let dto = BlockDTO(
            blockId: UUID().uuidString,
            blockedUserId: blockedUserId,
            userId: userId,
            status: Block.BlockStatus.active.rawValue
        )
        
        guard let values = dto.asDictionary else { return Single.just(()) }
        
        return firebase.createDocument(
            collection: .blocks,
            document: dto.blockId,
            values: values
        )
    }
    
    
    func removeBlockUser(blockId: String) -> Single<Void> {
        return firebase.deleteDocument(
            collection: .blocks,
            document: blockId
        )
    }
    
    func fetchBlockedUser() -> Single<[Block]> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return firebase.getDocument(
            collection: .blocks,
            field: "userId",
            in: [userId]
        )
        .map { dto -> [Block] in
            dto.compactMap { $0.toObject(BlockDTO.self)?.toBlock() }
        }
    }
}

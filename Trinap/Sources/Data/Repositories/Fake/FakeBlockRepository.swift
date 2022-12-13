//
//  FakeBlockRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct FakeBlockRepository: BlockRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    
    // MARK: - Initializers
    init(isSucceedCase: Bool = FakeRepositoryEnvironment.isSucceedCase) {
        self.isSucceedCase = isSucceedCase
    }
    
    // MARK: - Methods
    func blockUser(blockedUserId: String) -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
    
    func blockUser(blockedUserId: String, blockId: String) -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
    
    func removeBlockUser(blockId: String) -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
    
    func fetchBlockedUser() -> Single<[Block]> {
        return execute(successValue: Block.stubs()).asSingle()
    }
}

extension Block {
    
    static func stubs(_ count: Int = 10) -> [Block] {
        var blocks = [Block]()
        
        for i in 0..<count {
            let block = Block(
                blockId: "id\(i)",
                blockedUserId: "userId\(i)",
                userId: "userId\(i)"
            )
            
            blocks.append(block)
        }
        
        return blocks
    }
}

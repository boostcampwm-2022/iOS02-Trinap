//
//  DefaultCreateBlockUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/03.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultCreateBlockUseCase: CreateBlockUseCase {
    
    // MARK: Properties
    private let blockRepository: BlockRepository
    
    // MARK: Initializers
    init(blockRepository: BlockRepository) {
        self.blockRepository = blockRepository
    }
    
    // MARK: Methods
    func create(blockedUserId: String) -> Single<Void> {
        return blockRepository.blockUser(blockedUserId: blockedUserId)
    }
    
    func create(blockedUserId: String, blockId: String) -> Single<Void> {
        return self.blockRepository.blockUser(
            blockedUserId: blockedUserId,
            blockId: blockId
        )
    }
}

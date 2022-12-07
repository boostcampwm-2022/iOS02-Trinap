//
//  DefaultRemoveBlockUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultRemoveBlockUseCase: RemoveBlockUseCase {
    
    // MARK: Properties
    private let blockRepository: BlockRepository
    
    // MARK: Initializers
    init(blockRepository: BlockRepository) {
        self.blockRepository = blockRepository
    }
    
    // MARK: Methods
    func removeBlockUser(blockId: String) -> Single<Void> {
        return self.blockRepository.removeBlockUser(blockId: blockId)
    }
}

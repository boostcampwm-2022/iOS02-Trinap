//
//  DefaultFetchBlockUsersUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/04.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchBlockUsersUseCase: FetchBlockUsersUseCase {
    
    // MARK: Properties
    private let blockRepository: BlockRepository
    private let userRepository: UserRepository
    
    // MARK: Initializers
    init(
        blockRepository: BlockRepository,
        userRepository: UserRepository
    ) {
        self.blockRepository = blockRepository
        self.userRepository = userRepository
    }
    
    // MARK: Methods
    func fetchBlockUsers() -> Observable<[Block.BlockedUser]> {
        return blockRepository.fetchBlockedUser()
            .asObservable()
            .map { blocks -> ([Block], [String]) in
                let blockIds = blocks.map { $0.blockedUserId }
                return (blocks, blockIds)
            }
            .withUnretained(self)
            .flatMap { owner, blockedInfo -> Observable<[Block.BlockedUser]> in
                let (blocks, blockedUserIds) = blockedInfo
                return owner.userRepository.fetchUsers(userIds: blockedUserIds)
                    .map { owner.makeBlockedUser(users: $0, blocks: blocks) }
            }
    }
    
    private func makeBlockedUser(users: [User], blocks: [Block]) -> [Block.BlockedUser] {
        var blockedUsers: [Block.BlockedUser] = []
        for user in users {
            for block in blocks where user.userId == block.blockedUserId {
                blockedUsers.append(Block.BlockedUser(blockId: block.blockId, blockedUser: user))
            }
        }
        
        return blockedUsers
    }
}

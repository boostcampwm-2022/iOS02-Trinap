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
    func fetchBlockUsers() -> Observable<[User]> {
        return blockRepository.fetchBlockedUser()
            .asObservable()
            .map { $0.map { $0.blockedUserId } }
            .withUnretained(self)
            .flatMap { owner, blockedIds -> Observable<[User]> in
                owner.userRepository.fetchUsers(userIds: blockedIds)
            }
    }
}

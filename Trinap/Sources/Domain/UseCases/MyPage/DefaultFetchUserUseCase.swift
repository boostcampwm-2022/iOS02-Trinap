//
//  DefaultFetchUserUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchUserUseCase: FetchUserUseCase {
    
    private let userRepository: UserRepository
    private let tokenManager: TokenManager
    
    init(
        userRepository: UserRepository,
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.userRepository = userRepository
        self.tokenManager = tokenManager
    }
    
    func fetchUserInfo() -> Observable<User> {
        tokenManager.save(token: "RbsMGyMhufNr4wqF2blOzvL9y092", with: .userId)
        
        guard let token = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return userRepository.fetch(userId: token)
    }
}

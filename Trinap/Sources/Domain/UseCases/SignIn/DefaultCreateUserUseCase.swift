//
//  DefaultCreateUserUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultCreateUserUseCase: CreateUserUseCase {
    
    // MARK: - Properties
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    // MARK: - Initializers
    init(authRepository: AuthRepository, userRepository: UserRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    // MARK: - Methods
    func createUser(with nickName: String) -> Observable<Void> {
        return self.authRepository.createUser(nickname: nickName)
    }
    
    func createRandomNickname() -> Observable<String> {
        return self.userRepository.createRandomNickname()
    }
}

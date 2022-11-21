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
    
    // MARK: - Initializers
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // MARK: - Methods
    func createUser(with nickName: String) -> Observable<Void> {
        return self.authRepository.createUser(nickname: nickName)
    }
}

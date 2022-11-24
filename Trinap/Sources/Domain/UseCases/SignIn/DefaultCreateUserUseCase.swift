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
    private let photographerRepository: PhotographerRepository
    
    // MARK: - Initializers
    init(
        authRepository: AuthRepository,
        userRepository: UserRepository,
        photographerRepository: PhotographerRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.photographerRepository = photographerRepository
    }
    
    // MARK: - Methods
    func createUser(with nickName: String) -> Observable<Void> {
        return self.authRepository.createUser(nickname: nickName)
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.photographerRepository.create(
                    photographer: Photographer(
                        photographerId: UUID().uuidString,
                        photographerUserId: "",
                        introduction: "",
                        latitude: 37.7,
                        longitude: 127,
                        tags: [],
                        pictures: [],
                        pricePerHalfHour: 0,
                        possibleDate: []
                    )
                )
            }
            .retry(3)
    }
    
    func createRandomNickname() -> Observable<String> {
        return self.userRepository.createRandomNickname()
    }
}

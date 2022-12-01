//
//  DefaultDropOutUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultDropOutUseCase: DropOutUseCase {
    
    // MARK: - Properties
    private let authRepository: AuthRepository
    private let photographerRepository: PhotographerRepository
    
    // MARK: - Initializers
    init(
        authRepository: AuthRepository,
        photographerRepository: PhotographerRepository
    ) {
        self.authRepository = authRepository
        self.photographerRepository = photographerRepository
    }
    
    // MARK: - Methods
    func dropOut() -> Observable<Bool> {
        return self.photographerRepository.fetchDetailPhotographer()
            .map { photographer -> String in
                return photographer.photographerId
            }
            .withUnretained(self)
            .flatMap { owner, photographerId in
                return owner.authRepository.removePhotographerInfo(with: photographerId)
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.authRepository.removeUser()
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.authRepository.dropOut()
            }
            .asObservable()
            .map { true }
            .catchAndReturn(false)
    }
}

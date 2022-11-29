//
//  DefaultSignOutUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultSignOutUseCase: SignOutUseCase {
    
    // MARK: - Properties
    private let authRepository: AuthRepository
    
    // MARK: - Initializers
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // MARK: - Methods
    func signOut() -> Observable<Bool> {
        return self.authRepository.signOut()
            .asObservable()
            .flatMap { _ -> Observable<Void> in
                return self.authRepository.deleteFcmToken()
            }
            .map { true }
            .catchAndReturn(false)
    }
}

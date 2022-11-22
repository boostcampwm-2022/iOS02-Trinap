//
//  SplashViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxRelay
import RxSwift

final class SplashViewModel: ViewModelType {
    
    struct Input { }
    
    struct Output { }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    weak var coordinator: AppCoordinator?
    private let signInUseCase: SignInUseCase
    private let auth = DefaultAuthRepository()
    
    // MARK: - Initializer
    init(
        signInUseCase: SignInUseCase,
        coordinator: AppCoordinator
    ) {
        self.signInUseCase = signInUseCase
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func autoSignInFlow() {
        self.signInUseCase.autoSignIn()
            .withUnretained(self)
            .subscribe(onNext: { owner, isSignIn in
                isSignIn ? owner.coordinator?.connectTabBarFlow() : owner.coordinator?.connectAuthFlow()
            })
            .disposed(by: disposeBag)
    }
}

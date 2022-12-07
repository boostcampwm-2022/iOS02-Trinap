//
//  SignInViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxRelay
import RxSwift

final class SignInViewModel: ViewModelType {
    
    struct Input {
        let signInButtonTap: Observable<Void>
        let credential: Observable<(OAuthCredential, String)>
    }
    
    struct Output {
        let presentSignInWithApple: Signal<Void>
        let signInFailure: Signal<Void>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?
    private let signInUseCase: SignInUseCase
    private let signInFailure = PublishRelay<Void>()
    
    // MARK: - Initializer
    init(
        signInUseCase: SignInUseCase,
        coordinator: AuthCoordinator
    ) {
        self.signInUseCase = signInUseCase
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.credential
            .withUnretained(self)
            .flatMap { owner, credential in
                owner.signInUseCase.signIn(with: credential)
            }
            .subscribe(onNext: { [weak self] reuslt in
                guard let self else { return }
                switch reuslt {
                case.signUp:
                    self.coordinator?.showCreateUserViewController()
                case .signIn:
                    self.signInUseCase.updateFcmToken()
                        .subscribe(onNext: {
                            self.coordinator?.finish()
                        })
                        .disposed(by: self.disposeBag)
                case .failure:
                    Logger.print("Sign 실패")
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            presentSignInWithApple: input.signInButtonTap.asSignal(onErrorSignalWith: .empty()),
            signInFailure: signInFailure.asSignal()
        )
    }
}

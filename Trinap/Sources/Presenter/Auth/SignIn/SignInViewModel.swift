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
        let credential: Observable<(OAuthCredential, String)>
    }
    
    struct Output {
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
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }
                switch result {
                case.signUp:
                    self.coordinator?.showCreateUserViewController()
                case .signIn:
                    self.signInUseCase.updateFcmToken()
                        .subscribe(onNext: {
                            self.coordinator?.finish()
                        })
                        .disposed(by: self.disposeBag)
                case .failure:
                    self.coordinator?.presentErrorAlert()
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            signInFailure: signInFailure.asSignal()
        )
    }
}

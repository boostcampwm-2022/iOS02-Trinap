//
//  CreateUserViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class CreateUserViewModel: ViewModelType {
    
    struct Input {
        let nickname: Observable<String>
        let signUpButtonTap: Observable<Void>
    }
    
    struct Output {
        let signUpButtonEnable: Driver<Bool>
        let signUpFailure: Signal<Void>
    }
    
    // MARK: - Properties
    weak var coordinator: AuthCoordinator?
    private let createUserUseCase: CreateUserUseCase
    private let signUpSuccess = PublishRelay<Void>()
    private let signUpFailure = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    
    
    // MARK: - Initializer
    init(
        createUserUseCase: CreateUserUseCase,
        coordinator: AuthCoordinator
    ) {
        self.createUserUseCase = createUserUseCase
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.signUpButtonTap
            .withLatestFrom(input.nickname)
            .withUnretained(self)
            .flatMap { owner, nickname in
                return owner.createUserUseCase.createUser(with: nickname)
            }
            .subscribe { [weak self] in
                Logger.print("유저 생성 성공!")
                self?.coordinator?.finish()
            }
            .disposed(by: disposeBag)
        
        let signUpButtonEnable = input.nickname
            .map { nickname in
                return !nickname.isEmpty ? true : false
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        
        return Output(
            signUpButtonEnable: signUpButtonEnable,
            signUpFailure: signUpFailure.asSignal()
        )
    }
}

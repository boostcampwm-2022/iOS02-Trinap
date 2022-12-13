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
        let generateButtonTap: Observable<Void>
        let backButtonTap: Signal<Void>
    }
    
    struct Output {
        let signUpButtonEnable: Driver<Bool>
        let randomNickName: Observable<String>
    }
    
    // MARK: - Properties
    weak var coordinator: AuthCoordinator?
    private let createUserUseCase: CreateUserUseCase
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
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        let nickname = input.generateButtonTap
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.createUserUseCase.createRandomNickname()
            }
        
        let signUpButtonEnable = input.nickname
            .map { nickname in
                return !nickname.isEmpty ? true : false
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            signUpButtonEnable: signUpButtonEnable,
            randomNickName: nickname
        )
    }
}

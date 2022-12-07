//
//  DropOutViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/30.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class DropOutViewModel: ViewModelType {
    
    struct Input {
        let dropOutButtonTap: Observable<Void>
        let cancelButtonTap: Observable<Void>
        let backButtonTap: Signal<Void>
    }
    
    struct Output { }
    
    // MARK: - Properties
    weak var coordinator: MyPageCoordinator?
    private let dropOutUseCase: DropOutUseCase
    let disposeBag = DisposeBag()
    
    
    // MARK: - Initializer
    init(
        coordinator: MyPageCoordinator?,
        dropOutUseCase: DropOutUseCase
    ) {
        self.coordinator = coordinator
        self.dropOutUseCase = dropOutUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.cancelButtonTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        input.dropOutButtonTap
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.dropOutUseCase.dropOut()
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, isDropOut in
                if isDropOut {
                    owner.coordinator?.finish()
                } else {
                    Logger.print(isDropOut)
                }
            })
            .disposed(by: disposeBag)
        
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}

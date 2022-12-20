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
    
    struct Output {
        let droppedOut: Observable<Void>
    }
    
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
        
        let droppedOut = input.dropOutButtonTap
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.dropOutUseCase.dropOut()
            }
            .do(onNext: { [weak self] isDropOut in
                if isDropOut {
                    self?.coordinator?.finish()
                } else {
                    Logger.print(isDropOut)
                }
            })
            .map { _ in return }
        
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        return Output(droppedOut: droppedOut)
    }
}

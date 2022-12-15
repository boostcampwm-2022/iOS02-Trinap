//
//  OpenSourceListViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class OpenSourceListViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let backButtonTap: Signal<Void>
    }
    
    struct Output {
        let openSourceInfo: Observable<[OpenSourceInfo]>
    }
    
    // MARK: - Properties
    weak var coordinator: MyPageCoordinator?
    let fetchOpenSourceListUseCase: FetchOpenSourceListUseCase
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(
        coordinator: MyPageCoordinator?,
        fetchOpenSourceListUseCase: FetchOpenSourceListUseCase
    ) {
        self.coordinator = coordinator
        self.fetchOpenSourceListUseCase = fetchOpenSourceListUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let openSourceInfo = input.viewWillAppear
            .map { _ in
                self.fetchOpenSourceListUseCase.fetchOpenSource()
            }
            
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        return Output(openSourceInfo: openSourceInfo)
    }
}

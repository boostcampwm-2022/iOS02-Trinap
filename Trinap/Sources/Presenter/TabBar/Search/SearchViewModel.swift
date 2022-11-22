//
//  SearchViewModel.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    struct Input {
        var searchText: Observable<String>
        var selectedSpace: Observable<Space>
    }
    
    struct Output {
        var spaces: Driver<[Space]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    private let searchLocationUseCase: SearchLocationUseCase
    
    // MARK: - Initializer
    init(
        searchLocationUseCase: SearchLocationUseCase
    ) {
        self.searchLocationUseCase = searchLocationUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let spaces = input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMap { owner, value in
                owner.searchLocationUseCase.fetchSearchList(with: value)
            }
            .asDriver(onErrorJustReturn: [])
        
        input.selectedSpace
            .withUnretained(self)
            .subscribe(onNext: { owner, space in
                Logger.print("쨔스! \(space) 선택됨"))
                //TODO: coordinator로 space 전달하고 pop
            })
            .disposed(by: disposeBag)
        
        return Output(spaces: spaces)
    }
}

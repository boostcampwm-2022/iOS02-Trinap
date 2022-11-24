//
//  PhotographerListViewModel.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class PhotographerListViewModel: ViewModelType {
    
    struct Input {
        let searchTrigger: Observable<Void>
    }
    
    struct Output {
        photographers
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let searchText = BehaviorRelay<String>(value: "")
    
    private let photographersUseCase: FetchPhotographersUseCase
    
    // MARK: - Initializer
    init(photographersUseCase: FetchPhotographersUseCase) {
        self.photographersUseCase = photographersUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        return Output(<#code#>)
    }
}

//
//  LocationShareViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class LocationShareViewModel: ViewModelType {
    
    struct Input {
        <#code#>
    }
    
    struct Output {
        <#code#>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    private let <#useCase#>: <#UseCaseType#>
    
    // MARK: - Initializer
    init(<#parameters#>) {
        <#statements#>
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        return Output(<#code#>)
    }
}

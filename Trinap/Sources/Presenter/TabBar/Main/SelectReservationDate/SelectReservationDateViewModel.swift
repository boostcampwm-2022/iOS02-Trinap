//
//  SelectReservationDateViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

final class SelectReservationDateViewModel: ViewModelType {
    
    struct Input {
        let selectDoneButtonTap: Observable<Void>
        let startDate: Observable<SelectedTime>
        let endDate: Observable<SelectedTime>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private let useCase: CreateReservationDateUseCase = CreateReservationDateUseCase()
    
    // MARK: - Initializers
    
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let resultDate = Observable.combineLatest(
            input.startDate,
            input.endDate
        ).map { (startDate, endDate) in
            
        }
        return Output()
    }
}

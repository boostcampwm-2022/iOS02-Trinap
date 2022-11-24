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
        let selectedDate: Observable<ReservationDate>
        let deselectedDate: Observable<TimeSection>
    }
    
    struct Output {
        let newSelectDate: Observable<ReservationDate?>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private var selectedStartDate: ReservationDate?
    private var selectedEndDate: ReservationDate?
    
    private let useCase: CreateReservationDateUseCase = CreateReservationDateUseCase()
    
    // MARK: - Initializers
    
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.deselectedDate
            .withUnretained(self)
            .subscribe(onNext: { owner, timeType in
                switch timeType {
                case .startDate:
                    owner.selectedStartDate = nil
                case .endDate:
                    owner.selectedEndDate = nil
                }
            })
            .disposed(by: disposeBag)
        
        let newSelectDate = input.selectedDate
            .withUnretained(self)
            .map { (owner, selectedDate) -> ReservationDate? in
                switch selectedDate.type {
                case .startDate:
                    owner.selectedStartDate = selectedDate
                    if let endDate = owner.selectedEndDate {
                        let newDate = owner.useCase.selectedStartDate(
                            startDate: selectedDate,
                            endDate: endDate
                        )
                        owner.selectedEndDate = newDate != nil ? newDate : owner.selectedEndDate
                        return newDate
                    }
                    
                    let newDate = owner.useCase.createReservationDate(
                        date: selectedDate.date,
                        minute: 30,
                        type: .endDate
                    )
                    owner.selectedEndDate = newDate
                    
                    return newDate
                case .endDate:
                    owner.selectedEndDate = selectedDate
                    if let startDate = owner.selectedStartDate {
                        let newDate = owner.useCase.selectedEndDate(
                            startDate: startDate,
                            endDate: selectedDate
                        )
                        owner.selectedStartDate = newDate != nil ? newDate : owner.selectedStartDate
                        return newDate
                    }
                    
                    let newDate = owner.useCase.createReservationDate(
                        date: selectedDate.date,
                        minute: -30,
                        type: .startDate
                    )
                    owner.selectedStartDate = newDate
                    
                    return newDate
                }
            }
        return Output(newSelectDate: newSelectDate)
    }
}

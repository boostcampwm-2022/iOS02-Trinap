//
//  SelectReservationDateViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

final class SelectReservationDateViewModel: ViewModelType {
    
    struct Input {
        let calendarDateTap: Observable<Date>
        let selectDoneButtonTap: Observable<Void>
        let selectedDate: Observable<ReservationDate>
        let deselectedDate: Observable<ReservationTimeSection>
    }
    
    struct Output {
        let newSelectDate: Observable<ReservationDate?>
        let reservationTime: Observable<([Date], [Date])>
        let selectDoneButtonEnable: Observable<Bool>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private var selectedStartDate = BehaviorRelay<ReservationDate?>(value: nil)
    private var selectedEndDate = BehaviorRelay<ReservationDate?>(value: nil)
    weak var coordinator: MainCoordinator?
    private var createReservationDateUseCase: CreateReservationDateUseCase
    
    // MARK: - Initializers
    init(
        createReservationDateUseCase: CreateReservationDateUseCase,
        coordinator: MainCoordinator
    ) {
        self.createReservationDateUseCase = createReservationDateUseCase
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.selectDoneButtonTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.dismissSelectReservationDateViewController()
            })
            .disposed(by: disposeBag)
        
        input.deselectedDate
            .withUnretained(self)
            .subscribe(onNext: { owner, timeType in
                switch timeType {
                case .startDate:
                    owner.selectedStartDate.accept(nil)
                case .endDate:
                    owner.selectedEndDate.accept(nil)
                }
            })
            .disposed(by: disposeBag)
        
        
        let newSelectDate = input.selectedDate
            .withUnretained(self)
            .map { owner, selectedDate -> ReservationDate? in
                switch selectedDate.type {
                case .startDate:
                    owner.selectedStartDate.accept(selectedDate)
                    if let endDate = owner.selectedEndDate.value {
                        let newDate = owner.createReservationDateUseCase.selectedStartDate(
                            startDate: selectedDate,
                            endDate: endDate
                        )
                        
                        if newDate != nil {
                            owner.selectedEndDate.accept(newDate)
                        }
                        
                        return newDate
                    }
                    
                    let newDate = owner.createReservationDateUseCase.createReservationDate(
                        date: selectedDate.date,
                        minute: 30,
                        type: .endDate
                    )
                    owner.selectedEndDate.accept(newDate)
                    
                    return newDate
                case .endDate:
                    owner.selectedEndDate.accept(selectedDate)
                    if let startDate = owner.selectedStartDate.value {
                        let newDate = owner.createReservationDateUseCase.selectedEndDate(
                            startDate: startDate,
                            endDate: selectedDate
                        )
                        
                        if newDate != nil {
                            owner.selectedStartDate.accept(newDate)
                        }
                        return newDate
                    }
                    
                    let newDate = owner.createReservationDateUseCase.createReservationDate(
                        date: selectedDate.date,
                        minute: -30,
                        type: .startDate
                    )
                    owner.selectedStartDate.accept(newDate)
                    
                    return newDate
                }
            }
        
        let reservationTime = input.calendarDateTap
            .withUnretained(self)
            .map { owner, date -> ([Date], [Date]) in
                owner.selectedStartDate.accept(nil)
                owner.selectedEndDate.accept(nil)
                
                let startDate = owner.createReservationDateUseCase.createStartDate(date: date)
                let endDate = owner.createReservationDateUseCase.createEndDate(date: startDate.first ?? Date())
                
                return (startDate, endDate)
            }
        
        let selectDoneButtonEnable = Observable
            .combineLatest(
                self.selectedStartDate.asObservable(),
                self.selectedEndDate.asObservable()
            )
            .map { startDate, endDate -> Bool in
                return startDate != nil && endDate != nil
            }
        
        return Output(
            newSelectDate: newSelectDate,
            reservationTime: reservationTime,
            selectDoneButtonEnable: selectDoneButtonEnable
        )
    }
}

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

protocol SelectReservationDateViewModelDelegate: AnyObject {
    func selectedReservationDate(startDate: Date, endDate: Date)
}

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
        let fetchPossibleDate: Driver<[Date]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private let selectedStartDate = BehaviorRelay<ReservationDate?>(value: nil)
    private let selectedEndDate = BehaviorRelay<ReservationDate?>(value: nil)
    weak var coordinator: MainCoordinator?
    weak var delegate: SelectReservationDateViewModelDelegate?
    private let createReservationDateUseCase: CreateReservationDateUseCase
    private let possibleDate: BehaviorRelay<[Date]>
    
    // MARK: - Initializers
    init(
        createReservationDateUseCase: CreateReservationDateUseCase,
        coordinator: MainCoordinator,
        with possibleDate: [Date]
    ) {
        self.createReservationDateUseCase = createReservationDateUseCase
        self.coordinator = coordinator
        self.possibleDate = BehaviorRelay<[Date]>(value: possibleDate)
        self.possibleDate.accept(possibleDate)
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.selectDoneButtonTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard
                    let startDate = owner.selectedStartDate.value?.date,
                    let endDate = owner.selectedEndDate.value?.date
                else {
                    return
                }
                owner.delegate?.selectedReservationDate(startDate: startDate, endDate: endDate)
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
                    return owner.selectedStartDate(selectedDate)
                case .endDate:
                    return owner.selectedEndDate(selectedDate)
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
        
        let fetchPossibleDate = self.possibleDate
            .asDriver()
        
        return Output(
            newSelectDate: newSelectDate,
            reservationTime: reservationTime,
            selectDoneButtonEnable: selectDoneButtonEnable,
            fetchPossibleDate: fetchPossibleDate
        )
    }
}

// MARK: - Private Functions
private extension SelectReservationDateViewModel {
    func selectedStartDate(_ selectedDate: ReservationDate) -> ReservationDate? {
        self.selectedStartDate.accept(selectedDate)
        if let endDate = self.selectedEndDate.value {
            let newDate = self.createReservationDateUseCase.selectedStartDate(
                startDate: selectedDate,
                endDate: endDate
            )
            
            if newDate != nil {
                self.selectedEndDate.accept(newDate)
            }
            
            return newDate
        }
        
        let newDate = self.createReservationDateUseCase.createReservationDate(
            date: selectedDate.date,
            minute: 30,
            type: .endDate
        )
        self.selectedEndDate.accept(newDate)
        
        return newDate
    }
    
    func selectedEndDate(_ selectedDate: ReservationDate) -> ReservationDate? {
        self.selectedEndDate.accept(selectedDate)
        if let startDate = self.selectedStartDate.value {
            let newDate = self.createReservationDateUseCase.selectedEndDate(
                startDate: startDate,
                endDate: selectedDate
            )
            
            if newDate != nil {
                self.selectedStartDate.accept(newDate)
            }
            return newDate
        }
        
        let newDate = self.createReservationDateUseCase.createReservationDate(
            date: selectedDate.date,
            minute: -30,
            type: .startDate
        )
        self.selectedStartDate.accept(newDate)
        
        return newDate
    }
}

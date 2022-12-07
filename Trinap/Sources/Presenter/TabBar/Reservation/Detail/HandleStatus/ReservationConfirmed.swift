//
//  ReservationConfirmed.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct ReservationConfirmed {
    
    private typealias Configurations = ReservationStatusConfigurations
    private typealias Configuration = ReservationStatusConfigurations.Configuration
    
    // MARK: - Properties
    private let reservation: Reservation
    private let userType: Reservation.UserType
    
    private let makeCompletePhotoshootUseCase: () -> CompletePhotoshootUseCase
    private let makeCancelReservationRequestUseCase: () -> CancelReservationRequestUseCase
    
    // MARK: - Initializers
    init(
        reservation: Reservation,
        userType: Reservation.UserType,
        completePhotoshootUseCaseFactory: @escaping () -> CompletePhotoshootUseCase,
        cancelReservationRequestUseCaseFactory: @escaping () -> CancelReservationRequestUseCase
    ) {
        self.reservation = reservation
        self.userType = userType
        self.makeCompletePhotoshootUseCase = completePhotoshootUseCaseFactory
        self.makeCancelReservationRequestUseCase = cancelReservationRequestUseCaseFactory
    }
}

extension ReservationConfirmed: ReservationStatusConvertible {
    
    func convert() -> ReservationStatusConfigurations {
        switch userType {
        case .photographer:
            return Configurations(
                status: Configuration(title: "예약 확정", fillType: .fill, style: .primary),
                primary: Configuration(title: "예약 확정", fillType: .fill, style: .disabled),
                secondary: Configuration(title: "예약 취소", fillType: .border, style: .black)
            )
        case .customer:
            return separateCustomerConfigurationsByDate()
        }
    }
    
    private func separateCustomerConfigurationsByDate() -> Configurations {
        if isReservationEnded() {
            return Configurations(
                status: Configuration(title: "예약 확정", fillType: .fill, style: .primary),
                primary: Configuration(title: "촬영 완료", fillType: .fill, style: .disabled),
                secondary: Configuration(title: "예약 취소", fillType: .border, style: .black)
            )
        } else {
            return Configurations(
                status: Configuration(title: "예약 확정", fillType: .fill, style: .primary),
                primary: Configuration(title: "촬영 완료", fillType: .fill, style: .primary),
                secondary: Configuration(title: "예약 취소", fillType: .fill, style: .disabled)
            )
        }
    }
    
    private func isReservationEnded() -> Bool {
        return reservation.reservationEndDate >= Date()
    }
}

extension ReservationConfirmed: ReservationUseCaseExecutable {
    
    func executePrimaryAction() -> Observable<Reservation>? {
        if userType == .customer && isReservationEnded() {
            return makeCompletePhotoshootUseCase().execute(reservation: reservation)
        }
        
        return nil
    }
    
    func executeSecondaryAction() -> Observable<Reservation>? {
        if userType == .customer && isReservationEnded() { return nil }
        
        return makeCancelReservationRequestUseCase().execute(reservation: reservation)
    }
}

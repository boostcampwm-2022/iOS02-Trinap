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
    
    // MARK: - Initializers
    init(reservation: Reservation, userType: Reservation.UserType) {
        self.reservation = reservation
        self.userType = userType
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
            // TODO: CompletePhotoshootUseCase
#warning("유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기")
            return mockReservationResult()
        }
        
        return nil
    }
    
    func executeSecondaryAction() -> Observable<Reservation>? {
        if userType == .customer && isReservationEnded() { return nil }
        
        // TODO: CancelReservationRequestUseCase
#warning("유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기")
        return mockReservationResult()
    }
}

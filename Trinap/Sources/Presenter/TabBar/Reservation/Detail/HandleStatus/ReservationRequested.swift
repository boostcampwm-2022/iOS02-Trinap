//
//  ReservationRequested.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

struct ReservationRequested {
    
    private typealias Configurations = ReservationStatusConfigurations
    private typealias Configuration = ReservationStatusConfigurations.Configuration
    
    // MARK: - Properties
    private let reservation: Reservation
    private let userType: Reservation.UserType
    
    private let makeAcceptReservationRequestUseCase: () -> AcceptReservationRequestUseCase
    private let makeCancelReservationRequestUseCase: () -> CancelReservationRequestUseCase
    
    // MARK: - Initializers
    init(
        reservation: Reservation,
        userType: Reservation.UserType,
        acceptReservationRequestUseCaseFactory: @escaping () -> AcceptReservationRequestUseCase,
        cancelReservationRequestUseCaseFactory: @escaping () -> CancelReservationRequestUseCase
    ) {
        self.reservation = reservation
        self.userType = userType
        self.makeAcceptReservationRequestUseCase = acceptReservationRequestUseCaseFactory
        self.makeCancelReservationRequestUseCase = cancelReservationRequestUseCaseFactory
    }
}

extension ReservationRequested: ReservationStatusConvertible {
    
    func convert() -> ReservationStatusConfigurations {
        switch userType {
        case .photographer:
            return Configurations(
                status: Configuration(title: "예약 요청", fillType: .fill, style: .secondary),
                primary: Configuration(title: "수락", fillType: .fill, style: .primary),
                secondary: Configuration(title: "요청 거절", fillType: .border, style: .black)
            )
        case .customer:
            return Configurations(
                status: Configuration(title: "예약 요청", fillType: .fill, style: .secondary),
                primary: Configuration(title: "수락 대기", fillType: .fill, style: .disabled),
                secondary: Configuration(title: "요청 취소", fillType: .border, style: .black)
            )
        }
    }
}

extension ReservationRequested: ReservationUseCaseExecutable {
    
    func executePrimaryAction() -> Observable<Reservation>? {
        switch userType {
        case .photographer:
            return makeAcceptReservationRequestUseCase().execute(reservation: reservation)
        case .customer:
            return nil
        }
    }
    
    func executeSecondaryAction() -> Observable<Reservation>? {
        return makeCancelReservationRequestUseCase().execute(reservation: reservation)
    }
}

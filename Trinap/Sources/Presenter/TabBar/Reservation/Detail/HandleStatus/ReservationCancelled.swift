//
//  ReservationCancelled.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

struct ReservationCancelled {
    
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

extension ReservationCancelled: ReservationStatusConvertible {
    
    func convert() -> ReservationStatusConfigurations {
        switch userType {
        case .photographer:
            return Configurations(
                status: Configuration(title: "예약 취소", fillType: .fill, style: .error),
                primary: nil,
                secondary: nil
            )
        case .customer:
            return Configurations(
                status: Configuration(title: "예약 취소", fillType: .fill, style: .error),
                primary: Configuration(title: "다시 예약", fillType: .fill, style: .primary),
                secondary: nil
            )
        }
    }
}

extension ReservationCancelled: ReservationUseCaseExecutable {
    
    func executePrimaryAction() -> Observable<Reservation>? {
        switch userType {
        case .photographer:
            return nil
        case .customer:
            // TODO: CreateReservationUseCase
#warning("유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기")
            return mockReservationResult()
        }
    }
}


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
    
    private let navigateToReservationDetail: (_ photographerUserId: String) -> Void
    
    // MARK: - Initializers
    init(
        reservation: Reservation,
        userType: Reservation.UserType,
        navigateToReservationDetail: @escaping (String) -> Void
    ) {
        self.reservation = reservation
        self.userType = userType
        self.navigateToReservationDetail = navigateToReservationDetail
    }
}

extension ReservationCancelled: ReservationStatusConvertible {
    
    func convert() -> ReservationStatusConfigurations {
        switch userType {
        case .photographer:
            return Configurations(
                status: Configuration(title: "예약 취소", fillType: .fill, style: .error),
                primary: Configuration(title: "예약이 취소되었습니다.", fillType: .fill, style: .disabled),
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
            navigateToReservationDetail(reservation.photographerUser.userId)
            return nil
        }
    }
}

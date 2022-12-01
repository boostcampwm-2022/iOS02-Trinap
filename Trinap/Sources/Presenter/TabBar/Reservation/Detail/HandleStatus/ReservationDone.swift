//
//  ReservationDone.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

struct ReservationDone {
    
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

extension ReservationDone: ReservationStatusConvertible {
    
    func convert() -> ReservationStatusConfigurations {
        switch userType {
        case .photographer:
            return Configurations(
                status: Configuration(title: "촬영 완료", fillType: .fill, style: .black),
                primary: Configuration(title: "촬영 완료", fillType: .fill, style: .disabled),
                secondary: nil
            )
        case .customer:
            return Configurations(
                status: Configuration(title: "촬영 완료", fillType: .fill, style: .black),
                primary: Configuration(title: "리뷰 작성", fillType: .fill, style: .primary),
                secondary: nil
            )
        }
    }
}

extension ReservationDone: ReservationUseCaseExecutable {
    
    func executePrimaryAction() -> Observable<Reservation>? {
        switch userType {
        case .photographer:
            return nil
        case .customer:
            // TODO: WriteReviewUseCase
#warning("유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기")
            return mockReservationResult()
        }
    }
}

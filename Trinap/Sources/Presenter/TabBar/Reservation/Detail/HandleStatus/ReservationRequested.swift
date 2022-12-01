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
    
    // MARK: - Initializers
    init(reservation: Reservation, userType: Reservation.UserType) {
        self.reservation = reservation
        self.userType = userType
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
            // TODO: AcceptReservationRequestUseCase
#warning("유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기")
            return mockReservationResult()
        case .customer:
            return nil
        }
    }
    
    func executeSecondaryAction() -> Observable<Reservation>? {
        // TODO: CancelReservationRequestUseCase
#warning("유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기")
        return mockReservationResult()
    }
}

#warning("유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기 유즈케이스 구현하면 없애기")
import Foundation

func mockReservationResult() -> Observable<Reservation> {
    return .create { observer in
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            observer.onNext(mockReservation)
        }
        
        observer.onCompleted()
        
        return Disposables.create()
    }
}

let mockReservation = Reservation(
    reservationId: UUID().uuidString,
    customerUser: customerUser,
    photographerUser: photographerUser,
    reservationStartDate: Date(),
    reservationEndDate: Date().addingTimeInterval(2 * 60 * 60),
    location: "제주시 한라산",
    status: .confirm
)

let customerUser = User(
    userId: UUID().uuidString,
    nickname: "고객고객",
    profileImage: nil,
    isPhotographer: false,
    fcmToken: "sometoken",
    status: .activate
)

let photographerUser = User(
    userId: UUID().uuidString,
    nickname: "작가가작",
    profileImage: nil,
    isPhotographer: true,
    fcmToken: "sometoken2",
    status: .activate
)

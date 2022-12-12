//
//  FakeReservationRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct FakeReservationRepository: ReservationRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    
    // MARK: - Initializers
    
    // MARK: - Methods
    func fetchUserType(customerId: String, photographerId: String) -> Reservation.UserType? {
        guard isSucceedCase else { return nil }
        
        if Bool.random() {
            return .customer
        } else {
            return .photographer
        }
    }
    
    func fetchReceivedReservations() -> Observable<[Reservation.Mapper]> {
        var reservations: [Reservation.Mapper] = []
        
        for i in 1...Int.random(in: 20...40) {
            reservations.append(.stub(reservationId: "reservationId\(i)"))
        }
        
        return execute(successValue: reservations)
    }
    
    func fetchSentReservations() -> Observable<[Reservation.Mapper]> {
        var reservations: [Reservation.Mapper] = []
        
        for i in 1...Int.random(in: 20...40) {
            reservations.append(.stub(reservationId: "reservationId\(i)"))
        }
        
        return execute(successValue: reservations)
    }
    
    func create(photographerUserId: String, startDate: Date, endDate: Date, coordinate: Coordinate) -> Observable<String> {
        return execute(successValue: UUID().uuidString)
    }
    
    func fetchReservation(reservationId: String) -> Observable<Reservation.Mapper> {
        let reservation = Reservation.Mapper.stub(reservationId: reservationId)
        
        return execute(successValue: reservation)
    }
    
    func updateReservationStatus(reservationId: String, status: Reservation.Status) -> Observable<Void> {
        return execute(successValue: ())
    }
}

extension Reservation.Mapper {
    
    static func stub(
        reservationId: String = UUID().uuidString,
        customerUserId: String = "userId1",
        photographerUserId: String = "userId2",
        reservationStartDate: Date = Date(),
        reservationEndDate: Date = Date().addingTimeInterval(3 * 24 * 60 * 60),
        latitude: Double = 37.123,
        longitude: Double = 123.123,
        status: Reservation.Status = [.request, .confirm, .request, .done].randomElement() ?? .request
    ) -> Reservation.Mapper {
        return Reservation.Mapper(
            reservationId: reservationId,
            customerUserId: customerUserId,
            photographerUserId: photographerUserId,
            reservationStartDate: reservationStartDate,
            reservationEndDate: reservationEndDate,
            latitude: latitude,
            longitude: longitude,
            status: status
        )
    }
}

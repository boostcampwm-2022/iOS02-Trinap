//
//  ReservationRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol ReservationRepository {
    
    // MARK: Methods
    func fetchUserType(customerId: String, photographerId: String) -> Reservation.UserType?
    func fetchReceivedReservations() -> Observable<[Reservation.Mapper]>
    func fetchSentReservations() -> Observable<[Reservation.Mapper]>
    func create(
        photographerUserId: String,
        startDate: Date,
        endDate: Date,
        coordinate: Coordinate
    ) -> Observable<Void>
    func fetchReservation(reservationId: String) -> Observable<Reservation.Mapper>

//    func addReservation(reservation: Reservation) -> Observable<Bool>
//    func deleteReservation(reservationId: String) -> Observable<Void>
//    func updateState(reservationId: String, state: Reservation.Status) -> Observable<Void>
}

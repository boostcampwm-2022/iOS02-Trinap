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
    func updateReservationStatus(reservationId: String, status: Reservation.Status) -> Observable<Void>
}

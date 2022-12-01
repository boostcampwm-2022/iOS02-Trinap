//
//  ReservationDTO.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ReservationDTO: Codable {
    
    // MARK: Properties
    let reservationId: String
    let customerUserId: String
    let photographerUserId: String
    let reservationStartDate: String
    let reservationEndDate: String
    let latitude: Double
    let longitude: Double
    let status: Reservation.Status
    
    // MARK: Initializers
    init(
        reservationId: String,
        customerUserId: String,
        photographerUserId: String,
        reservationStartDate: String,
        reservationEndDate: String,
        latitude: Double,
        longitude: Double,
        status: Reservation.Status
    ) {
        self.reservationId = reservationId
        self.customerUserId = customerUserId
        self.photographerUserId = photographerUserId
        self.reservationStartDate = reservationStartDate
        self.reservationEndDate = reservationEndDate
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
    }
    
    init(reservation: Reservation, coordinate: Coordinate) {
        self.reservationId = reservation.reservationId
        self.customerUserId = reservation.customerUser.userId
        self.photographerUserId = reservation.photographerUser.userId
        self.reservationStartDate = reservation.reservationStartDate.toString(type: .timeStamp)
        self.reservationEndDate = reservation.reservationEndDate.toString(type: .timeStamp)
        self.latitude = coordinate.lat
        self.longitude = coordinate.lng
        self.status = reservation.status
    }
    
    // MARK: Methods
    func toMapper() -> Reservation.Mapper {
        return Reservation.Mapper(
            reservationId: reservationId,
            customerUserId: customerUserId,
            photographerUserId: photographerUserId,
            reservationStartDate: Date.fromStringOrNow(reservationStartDate),
            reservationEndDate: Date.fromStringOrNow(reservationEndDate),
            latitude: latitude,
            longitude: longitude,
            status: status
        )
    }
}

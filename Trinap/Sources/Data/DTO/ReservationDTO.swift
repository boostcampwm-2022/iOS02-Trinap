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
    let reservationStartDate: Date
    let reservationEndDate: Date
    let latitude: Double
    let longitude: Double
    let status: Reservation.Status
    
    // MARK: Methods
    func toMapper() -> Reservation.Mapper {
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

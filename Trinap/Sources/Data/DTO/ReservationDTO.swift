//
//  ReservationDTO.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ReservationDTO: Codable {
    let customerserId: String
    let photographerUserId: String
    let reservationEndDate: String
    let reservationId: String
    let reservationStartDate: Date
    let status: String
    
    func toEntity() -> Reservation {
        Reservation(
            customerserId: self.customerserId,
            photographerUserId: self.photographerUserId,
            reservationEndDate: self.reservationEndDate,
            reservationId: self.reservationId,
            reservationStartDate: self.reservationStartDate
        )
    }
}

struct Reservation: Codable {
    let customerserId: String
    let photographerUserId: String
    let reservationEndDate: String
    let reservationId: String
    let reservationStartDate: Date
}

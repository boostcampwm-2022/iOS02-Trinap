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
    let status: String
    
    // TODO: Date 되어 있는 부분 String으로 변환하는 작업 처리
    // MARK: Methods
    func toModel() -> Reservation {
        return Reservation(
            reservationId: self.reservationId,
            customerUserId: self.customerUserId,
            photographerUserId: self.photographerUserId,
            reservationStartDate: self.reservationStartDate,
            reservationEndDate: self.reservationEndDate
        )
    }
}

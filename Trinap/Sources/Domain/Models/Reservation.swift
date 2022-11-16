//
//  Reservation.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Reservation: Codable {
    
    // MARK: Properties
    let reservationId: String
    let customerUserId: String
    let photographerUserId: String
    let reservationStartDate: Date
    let reservationEndDate: Date
}

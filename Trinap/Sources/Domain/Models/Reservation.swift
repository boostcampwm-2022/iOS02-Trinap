//
//  Reservation.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Reservation: Codable {

    enum State: String {
        case request
        case confirm
        case done
        case cancel
    }

    // MARK: Properties
    let reservationId: String
    let customerUserId: String
    let photographerUserId: String
    let reservationStartDate: Date
    let reservationEndDate: Date
}

extension Reservation: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reservationId)
    }
}

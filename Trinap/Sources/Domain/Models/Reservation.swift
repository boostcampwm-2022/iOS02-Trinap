//
//  Reservation.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Reservation {

    enum Status: String, Codable {
        case request
        case confirm
        case done
        case cancel
    }

    // MARK: Properties
    let reservationId: String
    let customerUser: User
    let photographerUser: User
    let reservationStartDate: Date
    let reservationEndDate: Date
    let location: String
    let status: Status
}

extension Reservation: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reservationId)
    }
}

// MARK: - Mapper struct
extension Reservation {
    
    struct Preview: Hashable {
        
        // MARK: - Properties
        let reservationId: String
        let customerUser: User
        let photographerUser: User
        let reservationStartDate: Date
        let status: Status
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(reservationId)
        }
    }
    
    struct Mapper {
        
        // MARK: - Properties
        let reservationId: String
        let customerUserId: String
        let photographerUserId: String
        let reservationStartDate: Date
        let reservationEndDate: Date
        let latitude: Double
        let longitude: Double
        let status: Status
    }
}

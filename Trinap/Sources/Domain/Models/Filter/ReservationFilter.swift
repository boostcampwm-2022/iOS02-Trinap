//
//  ReservationFilter.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum ReservationFilter: Int, CaseIterable, Hashable {
    case receive = 0
    case send
    
    var title: String {
        switch self {
        case .receive:
            return "받은 예약"
        case .send:
            return "보낸 예약"
        }
    }
}

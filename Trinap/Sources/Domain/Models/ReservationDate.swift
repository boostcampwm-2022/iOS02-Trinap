//
//  ReservationDate.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum ReservationTimeSection: String, Hashable {
    case startDate = "시작 시간"
    case endDate = "종료 시간"
}

struct ReservationDate: Hashable {
    let date: Date
    let type: ReservationTimeSection
}

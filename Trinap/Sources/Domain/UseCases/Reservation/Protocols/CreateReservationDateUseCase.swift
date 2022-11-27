//
//  CreateReservationDateUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

protocol CreateReservationDateUseCase {
    func createStartDate(date: Date) -> [Date]
    func createEndDate(date: Date) -> [Date]
    func selectedStartDate(startDate: ReservationDate, endDate: ReservationDate) -> ReservationDate?
    func selectedEndDate(startDate: ReservationDate, endDate: ReservationDate) -> ReservationDate?
    func createReservationDate(date: Date, minute: Int, type: TimeSection) -> ReservationDate
}

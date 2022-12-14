//
//  DefaultCreateReservationDateUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class DefaultCreateReservationDateUseCase: CreateReservationDateUseCase {
    
    // MARK: - Properties
    private lazy var calendar = Calendar.current
    
    // MARK: - Initializers
    
    // MARK: - Methods
    func createStartDate(date: Date) -> [Date] {
        var dateArray: [Date] = []
        let date = date
        let components = self.calendar.dateComponents([.year, .month, .day], from: date)
        let day = self.calendar.date(from: components) ?? Date()
        let newDate = self.calendar.date(byAdding: .day, value: +1, to: day) ?? Date()
        
        let hour = calendar.component(.hour, from: date) * 60
        let minute = calendar.component(.minute, from: date)
        let sum = hour + minute
        
        let count = (60 * 24 - sum) / 30
        for number in 0 ..< count {
            if let newDate = self.calendar.date(byAdding: .minute, value: -((number + 1) * 30), to: newDate) {
                dateArray.append(newDate)
            }
        }
        dateArray.reverse()
        Logger.printArray(dateArray.map { $0.toString(type: .yearToSecond) })
        return dateArray
    }
    
    func createEndDate(date: Date) -> [Date] {
        var dateArray: [Date] = []
        let date = date
        let components = self.calendar.dateComponents([.year, .month, .day], from: date)
        let day = self.calendar.date(from: components) ?? Date()
        let newDate = self.calendar.date(byAdding: .day, value: +1, to: day) ?? Date()
        
        let hour = calendar.component(.hour, from: date) * 60
        let minute = calendar.component(.minute, from: date)
        let sum = hour + minute
        
        let count = ((60 * 24 - sum) / 30) - 1
        
        if count >= 0 {
            dateArray.append(newDate)
            for number in 0 ..< count {
                if let newDate = self.calendar.date(byAdding: .minute, value: -((number + 1) * 30), to: newDate) {
                    dateArray.append(newDate)
                }
            }
        }
        
        dateArray.reverse()
        Logger.printArray(dateArray.map { $0.toString(type: .yearToSecond) })
        return dateArray
    }
    
    func selectedStartDate(startDate: ReservationDate, endDate: ReservationDate) -> ReservationDate? {
        if startDate.date >= endDate.date {
            return createReservationDate(
                date: startDate.date,
                minute: 30,
                type: .endDate
            )
        }
        
        return nil
    }
    
    func selectedEndDate(startDate: ReservationDate, endDate: ReservationDate) -> ReservationDate? {
        if startDate.date >= endDate.date {
            return self.createReservationDate(
                date: endDate.date,
                minute: -30,
                type: .startDate)
        }
        
        return nil
    }
    
    func createReservationDate(date: Date, minute: Int, type: ReservationTimeSection) -> ReservationDate {
        let newEndDate = self.calculateDate(by: minute, at: date)
        return ReservationDate(date: newEndDate, type: type)
    }
}

// MARK: - Private Function
extension DefaultCreateReservationDateUseCase {
    
    private func calculateDate(by minute: Int, at date: Date) -> Date {
        let newDate = self.calendar.date(byAdding: .minute, value: minute, to: date) ?? Date()
        return newDate
    }
}

//
//  DefaultConvertDateToStringUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class DefaultConvertDateToStringUseCase: ConvertDateToStringUseCase {

    // MARK: UI
    
    // MARK: Properties
    
    // MARK: Initializers
    
    // MARK: Methods
    func convert(startDate: Date, endDate: Date) -> String? {
        let startSeperated = startDate.toString(type: .yearToSecond).components(separatedBy: " ")
        let endSeperated = endDate.toString(type: .yearToSecond).components(separatedBy: " ")
        
        guard let date = startSeperated[safe: 0] else { return nil }
        let dateSeperated = date.components(separatedBy: "-")
        guard
            let month = dateSeperated[safe: 1],
            let day = dateSeperated[safe: 2]
        else { return nil }
        
        guard
            let startTime = startSeperated.last,
            let endTime = endSeperated.last
        else { return nil }
        let startHourToSec = startTime.components(separatedBy: ":")
        let endHourToSec = endTime.components(separatedBy: ":")
        guard
            let startHour = startHourToSec[safe: 0],
            let startMin = startHourToSec[safe: 1],
            let endHour = endHourToSec[safe: 0],
            let endMin = endHourToSec[safe: 1]
        else { return nil }

        let reservationDate = "\(month)/\(day)"
        let reservationStart = "\(startHour):\(startMin)"
        let reservationEnd = "\(endHour):\(endMin)"
        let dateInfo = "\(reservationDate) \(reservationStart)-\(reservationEnd)\n"
        return dateInfo
    }
}

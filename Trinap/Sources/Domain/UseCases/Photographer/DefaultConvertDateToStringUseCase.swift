//
//  DefaultConvertDateToStringUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class DefaultConvertDateToStringUseCase: ConvertDateToStringUseCase {
    
    // MARK: Methods
    func convert(startDate: Date, endDate: Date) -> String? {
        let date = startDate.toString(type: .monthAndDate2)
        let startTime = startDate.toString(type: .hourAndMinute)
        let endTime = endDate.toString(type: .hourAndMinute)
        let dateInfo = "\(date) \(startTime)-\(endTime)\n"
        return dateInfo
    }
}

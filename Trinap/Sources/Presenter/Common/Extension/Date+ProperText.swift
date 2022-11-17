//
//  Date+ProperText.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

extension Date {
    
    var properText: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return self.toString(type: .hourAndMinute)
        } else if calendar.isDateInYesterday(self) {
            return "어제"
        } else if self.isDateInCurrentYear() {
            return self.toString(type: .monthAndDate)
        } else {
            return self.toString(type: .yearAndMonthAndDate)
        }
    }
    
    private func isDateInCurrentYear() -> Bool {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let year = calendar.component(.year, from: self)
        
        return currentYear == year
    }
}

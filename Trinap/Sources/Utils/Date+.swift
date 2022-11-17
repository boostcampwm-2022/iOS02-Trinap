//
//  Date+.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

extension Date {
    
    enum Format: String {
        case yearToDay = "yyyy.MM.dd"
        case yearToSecond = "yyyy-MM-dd HH:mm:ss"
        case timeStamp = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    // MARK: Methods
    func toString(type: Format) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }

    func stringToDate(dateString: String, type: Format) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        return formatter.date(from: dateString)
    }
    
    func stringToDate(dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
}

extension Date {
    
    static func fromStringOrNow(_ string: String, ofFormat format: Format = .timeStamp) -> Date {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: string) ?? Date()
    }
}

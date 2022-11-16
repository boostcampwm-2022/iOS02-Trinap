//
//  Photographer.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Photographer {
        
    // MARK: - Properties
    let photographerId, location, introduction: String
    let tags, pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
}

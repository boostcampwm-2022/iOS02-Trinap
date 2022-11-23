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
    let photographerId, photographerUserId, introduction: String
    let latitude, longitude: Double
    let tags: [TagType]
    let pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
}

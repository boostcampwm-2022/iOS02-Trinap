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
    let photographerId, photographerUserId, location, introduction: String
    let tags: [TagType]
    let pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
}

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
    let photographerId, photographerUserId: String
    let introduction: String?
    let latitude, longitude: Double
    let tags: [TagType]
    let pictures: [String]
    let pricePerHalfHour: Int?
    var possibleDate: [Date]
    
    // MARK: - Methods
    static func createDefaultPhotographer() -> Photographer {
        return Photographer(
            photographerId: UUID().uuidString,
            photographerUserId: "",
            introduction: nil,
            latitude: Coordinate.seoulCoordinate.lat,
            longitude: Coordinate.seoulCoordinate.lng,
            tags: [],
            pictures: [],
            pricePerHalfHour: nil,
            possibleDate: []
        )
    }
}

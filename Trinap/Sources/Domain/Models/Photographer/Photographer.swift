//
//  Photographer.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum PhotographerSection: Int, Hashable {
    
    case profile = 0
    case photo
    case detail
    case review
    
    enum Item: Hashable {
        case profile(PhotographerProfile)
        case photo(Picture?)
        case detail(PhotographerDetailIntroduction)
        case summaryReview(ReviewSummary)
        case review(PhotographerReview)
    }
}

struct Photographer {
    
    // MARK: - Properties
    let photographerId, photographerUserId, introduction: String
    let latitude, longitude: Double
    let tags: [TagType]
    let pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
    
    // MARK: - Methods
    static func createDefaultPhotographer() -> Photographer {
        return Photographer(
            photographerId: UUID().uuidString,
            photographerUserId: "",
            introduction: "",
            latitude: 37.7,
            longitude: 127,
            tags: [],
            pictures: [],
            pricePerHalfHour: 0,
            possibleDate: []
        )
    }
}

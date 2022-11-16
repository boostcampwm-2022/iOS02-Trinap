//
//  PhotographerDTO.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct PhotographerDTO: Codable {
    
    enum Status: String, Codable {
        case activate, deactivate
    }
    
    // MARK: - Properties
    let photographerId, location, introduction: String
    let tags, pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
    let status: Status
    
    init(photographer: Photographer, status: Status) {
        self.photographerId = photographer.photographerId
        self.location = photographer.location
        self.introduction = photographer.introduction
        self.tags = photographer.tags
        self.pictures = photographer.pictures
        self.pricePerHalfHour = photographer.pricePerHalfHour
        self.possibleDate = photographer.possibleDate
        self.status = status
    }
    
    // MARK: - Methods
    func toModel() -> Photographer {
        return Photographer(
            photographerId: photographerId,
            location: location,
            introduction: introduction,
            tags: tags,
            pictures: pictures,
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: possibleDate
        )
    }
}

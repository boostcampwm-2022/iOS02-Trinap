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
    let photographerId: String
    var photographerUserId: String
    let location, introduction: String
    let tags, pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
    let status: Status
    
    init(photographer: Photographer, status: Status) {
        self.photographerId = photographer.photographerId
        self.photographerUserId = photographer.photographerUserId
        self.location = photographer.location
        self.introduction = photographer.introduction
        self.tags = photographer.tags.map { $0.rawValue }
        self.pictures = photographer.pictures
        self.pricePerHalfHour = photographer.pricePerHalfHour
        self.possibleDate = photographer.possibleDate
        self.status = status
    }
    
    // MARK: - Methods
    func toModel() -> Photographer {
        return Photographer(
            photographerId: photographerId,
            photographerUserId: photographerUserId,
            location: location,
            introduction: introduction,
            tags: tags.map { TagType(rawValue: $0) ?? .instagram },
            pictures: pictures,
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: possibleDate
        )
    }
}

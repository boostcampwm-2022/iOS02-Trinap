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
    let introduction: String
    let latitude, longitude: Double
    let tags, pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [String]
    let status: Status
    
    init(photographer: Photographer, status: Status) {
        self.photographerId = photographer.photographerId
        self.photographerUserId = photographer.photographerUserId
        self.introduction = photographer.introduction
        self.latitude = photographer.latitude
        self.longitude = photographer.longitude
        self.tags = photographer.tags.map { $0.rawValue }
        self.pictures = photographer.pictures
        self.pricePerHalfHour = photographer.pricePerHalfHour
        self.possibleDate = photographer.possibleDate.map { $0.toString(type: .yearToDay)}
        self.status = status
    }
    
    // MARK: - Methods
    func toModel() -> Photographer {
        return Photographer(
            photographerId: photographerId,
            photographerUserId: photographerUserId,
            introduction: introduction,
            latitude: latitude,
            longitude: longitude,
            tags: tags.map { TagType(rawValue: $0) ?? .instagram },
            pictures: pictures,
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: possibleDate.map { Date.fromStringOrNow($0, ofFormat: .yearToDay) }
        )
    }
}

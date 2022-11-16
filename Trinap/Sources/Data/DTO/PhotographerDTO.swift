//
//  PhotographerDTO.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct PhotographerDTO: Codable {
    let photograhperId, location, introduction, status: String
    let tags, pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
    
    init(photograhper: Photograhper, status: String) {
        self.photograhperId = photograhper.photograhperId
        self.location = photograhper.location
        self.introduction = photograhper.introduction
        self.tags = photograhper.tags
        self.pictures = photograhper.pictures
        self.pricePerHalfHour = photograhper.pricePerHalfHour
        self.possibleDate = photograhper.possibleDate
        self.status = status
    }
    
    func toEntity() -> Photograhper {
        return Photograhper(
            photograhperId: photograhperId,
            location: location,
            introduction: introduction,
            tags: tags,
            pictures: pictures,
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: possibleDate
        )
    }
}

struct Photograhper: Codable {
    let photograhperId, location, introduction: String
    let tags, pictures: [String]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
}

enum TagType: String {
    case all
    case family
}

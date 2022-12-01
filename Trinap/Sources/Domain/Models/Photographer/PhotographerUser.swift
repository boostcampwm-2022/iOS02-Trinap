//
//  PhotographerUser.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct PhotographerUser: Hashable {
    let nickname: String
    let profileImage: URL?
    let photographerId, photographerUserId, introduction: String
    let latitude, longitude: Double
    let location: String
    let tags: [TagType]
    let pricePerHalfHour: Int
    let possibleDate: [Date]
    var pictures: [Picture?]
    
    init(
        user: User,
        photographer: Photographer,
        location: String
    ) {
        self.nickname = user.nickname
        self.profileImage = user.profileImage
        self.photographerId = photographer.photographerId
        self.photographerUserId = photographer.photographerUserId
        self.introduction = photographer.introduction
        self.location = location
        self.latitude = photographer.latitude
        self.longitude = photographer.longitude
        self.tags = photographer.tags
        self.pricePerHalfHour = photographer.pricePerHalfHour
        self.possibleDate = photographer.possibleDate
        self.pictures = [nil] + photographer.pictures.map { url in
            Picture(isEditable: false, picture: url)
        }
    }
    
    func toPhotographer() -> Photographer {
        return Photographer(
            photographerId: photographerId,
            photographerUserId: photographerUserId,
            introduction: introduction,
            latitude: latitude,
            longitude: longitude,
            tags: tags,
            pictures: pictures.compactMap { $0?.picture },
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: possibleDate
        )
    }
}

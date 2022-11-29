//
//  PhotographerPreview.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct PhotographerPreview {
    
    // MARK: Properties
    let photographerId: String
    let photographerUserId: String
    let name: String
    let pictures: [String]
    let location: String
    let rating: Double

    // MARK: Initializers
    init(photographerId: String, photographerUserId: String, name: String, imageStrings: [String], location: String, rating: Double) {
        self.photographerId = photographerId
        self.photographerUserId = photographerUserId
        self.name = name
        self.pictures = imageStrings
        self.location = location
        self.rating = rating
    }
    
    init(photographer: Photographer,
         location: String,
         name: String,
         rating: Double) {
        self.photographerId = photographer.photographerId
        self.photographerUserId = photographer.photographerUserId
        self.name = name
        self.pictures = photographer.pictures
        self.location = location
        self.rating = rating
    }
}

extension PhotographerPreview: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(photographerId)
    }
}

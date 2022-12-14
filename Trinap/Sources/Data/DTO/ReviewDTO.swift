//
//  ReviewDTO.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ReviewDTO: Codable {
    
    // MARK: - Properties
    let creatorUserId, photographerUserId, reviewId, contents, status: String
    let createdAt: String
    let rating: Int
    
    // MARK: - Methods
    func toModel() -> Review {
        return Review(
            reviewId: reviewId,
            photographerUserId: photographerUserId,
            creatorUserId: creatorUserId,
            contents: contents,
            status: status,
            createdAt: Date.fromStringOrNow(createdAt),
            rating: rating
        )
    }
}
 

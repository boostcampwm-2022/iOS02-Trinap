//
//  Review.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum ReviewTarget: String {
    case customer = "creatorUserId"
    case photographer = "photographerUserId"
}

struct Review: Equatable, Hashable {
    let reviewId, photographerUserId, creatorUserId, contents, status: String
    let rating: Int
}

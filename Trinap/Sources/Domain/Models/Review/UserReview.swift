//
//  UserReivew.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

/// 작가에게 작성된 리뷰
struct UserReview: Hashable {
    let user: User
    let contents: String
    let rating: Int
    let createdAt: Date
}

//
//  CustomerReview.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

/// 유저가 작성한 리뷰
// TODO: - UI작업할 때 수정 필요
struct UserReview {
    let photorgrapher: Photographer
    let contents: String
    let rating: Int
}

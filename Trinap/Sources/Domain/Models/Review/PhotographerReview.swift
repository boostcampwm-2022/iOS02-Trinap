//
//  PhotograhperReview.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

/// 작가에게 작성된 리뷰
// TODO: - UI작업할 때 수정 필요
struct PhotographerReview: Hashable {
    let user: User
    let contents: String
    let rating: Int
}

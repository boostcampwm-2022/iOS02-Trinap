//
//  PhotographerSection.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum PhotographerSection: Int, Hashable {
    
    case profile = 0
    case photo
    case detail
    case review
    
    enum Item: Hashable {
        case profile(PhotographerUser)
        case photo(Picture?)
        case detail(PhotographerUser)
        case summaryReview(ReviewSummary)
        case review(UserReview)
    }
}

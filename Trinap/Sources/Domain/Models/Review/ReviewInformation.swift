//
//  ReviewInformation.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/26.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ReviewInformation {
    let summary: ReviewSummary
    let reviews: [PhotographerReview]
    
    func toDataSource() -> [EditPhotographerDataSource] {
        return [
            [.detail: [.summaryReview(self.summary)]],
            [.review: self.reviews.map { PhotographerSection.Item.review($0) } ]
        ]
    }
}

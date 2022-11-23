//
//  PhotographerFilter.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum PhotographerFitler: Int, CaseIterable, Hashable {
    case fortpolio = 0
    case detail
    case review

    var title: String {
        switch self {
        case .fortpolio:
            return "포트폴리오"
        case .detail:
            return "상세정보"
        case .review:
            return "리뷰"
        }
    }
}

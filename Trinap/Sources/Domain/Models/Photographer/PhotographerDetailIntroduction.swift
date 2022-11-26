//
//  PhotographerDetailIntroduction.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/26.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct PhotographerDetailIntroduction: Hashable {
    let introduction: String
    let pricePerHalfHour: Int
    
    func toDataSource() -> EditPhotographerDataSource {
        return [.detail: [.detail(self)] ]
    }
}

//
//  PhotographerProfile.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/26.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct PhotographerProfile: Hashable {
    let photographerId: String
    let photographerUserId: String
    let nickname: String
    let profielImage: URL?
    let location: String
    let tags: [TagType]
    let pricePerHalfHour: Int
    
    func toDataSource() -> EditPhotographerDataSource {
        return [.profile: [.profile(self)]]
    }
}

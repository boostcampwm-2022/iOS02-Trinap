//
//  Space.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Space {
    let id = UUID().uuidString
    let name: String
    let address: String
    let lat: Double
    let lng: Double
}

extension Space: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

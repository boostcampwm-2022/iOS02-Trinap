//
//  LocationShare.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct SharedLocation: Codable {
    
    let userId: String
    let latitude: Double
    let longitude: Double
}

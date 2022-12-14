//
//  Location.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Coordinate: Encodable {
    let lat: Double
    let lng: Double
    
    static var seoulCoordinate = Coordinate(lat: 37.553836, lng: 126.969652)
}

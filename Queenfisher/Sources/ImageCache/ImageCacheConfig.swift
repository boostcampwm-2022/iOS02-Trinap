//
//  ImageCacheConfig.swift
//  Queenfisher
//
//  Created by kimchansoo on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public struct Config {
    var totalCostLimit: Int =  150 * 1024 * 1024 // 메모리 캐시 최대 용량.
    var countLimit: Int = 50 // 메모리 캐시 최대 적재 개수.
}

public enum ConfigType {
    case lower
    case normal
    case high
    
    var config: Config {
        switch self {
        case .lower:
            return Config(
                totalCostLimit: 70 * 1024 * 1024,
                countLimit: 25
            )
        case .normal:
            return Config()
        case .high:
            return Config(
                totalCostLimit: 300 * 1024 * 1024,
                countLimit: 75
            )
        }
    }
}

//
//  ImageCacheConfig.swift
//  Queenfisher
//
//  Created by kimchansoo on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public struct MemoryConfig {
    var totalCostLimit: Int =  150 * 1024 * 1024 // 메모리 캐시 최대 용량.
    var countLimit: Int = 50 // 메모리 캐시 최대 적재 개수.
}

typealias DiskConfig = Int

public enum ConfigType {
    case lower
    case normal
    case high
    
    var memoryConfig: MemoryConfig {
        switch self {
        case .lower:
            return MemoryConfig(
                totalCostLimit: 70 * 1024 * 1024,
                countLimit: 25
            )
        case .normal:
            return MemoryConfig()
        case .high:
            return MemoryConfig(
                totalCostLimit: 300 * 1024 * 1024,
                countLimit: 75
            )
        }
    }
    
    var diskConfig: DiskConfig {
        switch self {
        case .lower:
            return 30
        case .normal:
            return 50
        case .high:
            return 70
        }
    }
}

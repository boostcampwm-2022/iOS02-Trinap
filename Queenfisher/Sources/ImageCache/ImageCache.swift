//
//  ImageCache.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public final class ImageCache {
    
    public struct Config {
        var totalCostLimit: Int =  150 * 1024 * 1024 // 메모리 캐시 최대 용량.
        var countLimit: Int = 50 // 메모리 캐시 최대 적재 개수.
//        var imageCostLimit: Int = 30 * 1024 * 1024 // 하나의 이미지 최대 용량.
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
    
    // MARK: - Properties
    private static let shared = ImageCache()
    
    private let memoryImageCache: DefaultImageCache
        
    // MARK: Initializers
    init(performance: ConfigType = .normal) {
        memoryImageCache = DefaultImageCache(
            totalCostLimit: performance.config.totalCostLimit,
            countLimit: performance.config.countLimit
        )
    }
    
    // MARK: - Methods
    public static func instance() -> ImageCacheProtocol {
        return self.shared.memoryImageCache
    }
}

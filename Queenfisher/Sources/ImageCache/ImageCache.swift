//
//  ImageCache.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public final class ImageCache {
    
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
    public static func instance(performance: ConfigType = .normal) -> ImageCacheProtocol {
        self.shared.memoryImageCache.config(
            totalCostLimit: performance.config.totalCostLimit,
            countLimit: performance.config.totalCostLimit
        )
        return self.shared.memoryImageCache
    }
}

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
    
    private let hybridImageCache: DefaultImageCache
        
    // MARK: Initializers
    init(performance: ConfigType = .normal) {
        hybridImageCache = DefaultImageCache(configType: performance)
    }
    
    // MARK: - Methods
    public static func instance(performance: ConfigType = .normal) -> ImageCacheProtocol {
        self.shared.hybridImageCache.config(performance)
        return self.shared.hybridImageCache
    }
}

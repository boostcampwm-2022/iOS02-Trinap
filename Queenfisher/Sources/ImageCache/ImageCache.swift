//
//  ImageCache.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public final class ImageCache {
    
    /// 이미지 캐싱 위치를 나타냅니다.
    public enum Policy {
        case memory, disk
    }
    
    // MARK: - Properties
    private static let shared = ImageCache()
    
    private lazy var memoryImageCache: MemoryImageCache = {
        return MemoryImageCache()
    }()
    
    private lazy var diskImageCache: DiskImageCache = {
        return DiskImageCache()
    }()
    
    // MARK: - Methods
    public static func policy(_ policy: Policy) -> ImageCacheProtocol {
        switch policy {
        case .memory:
            return Self.shared.memoryImageCache
        case .disk:
            return Self.shared.diskImageCache
        }
    }
}

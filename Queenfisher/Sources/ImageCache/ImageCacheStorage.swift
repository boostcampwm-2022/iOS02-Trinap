//
//  ImageCacheStorage.swift
//  Queenfisher
//
//  Created by kimchansoo on 2022/12/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public final class MemoryCacheStorage {
    
    // MARK: Properties
    private let memoryCache = NSCache<NSString, NSData>()
    
    // MARK: Initializers
    
    // MARK: Methods
    
    public func fetch(at url: URL) -> CacheableImage? {
        let key = key(for: url)

        if let data = memoryCache.object(forKey: key) {
            let image = try? JSONDecoder().decode(CacheableImage.self, from: data as Data)
            return image
        }
        else {
            return nil
        }
    }
    
    public func save(at url: URL, of cacheableImage: CacheableImage) {
        let key = key(for: url)
        guard let encoded = try? JSONEncoder().encode(cacheableImage) as NSData else { return }
        self.memoryCache.setObject(encoded, forKey: key)
    }
    
    func config(
        countLimit: Int,
        totalCostLimit: Int
    ) {
        memoryCache.totalCostLimit = totalCostLimit
        memoryCache.countLimit = countLimit
    }
    
    private func key(for url: URL) -> NSString {
        return url.absoluteString as NSString
    }
}

public final class DiskCacheStorage {
    
    // MARK: - Properties
    private let fileManager = FileManager.default
    
    private var cacheURL: URL {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    private var limitCount: Int
    
    // MARK: Initializers
    init() {
        self.limitCount = 30
    }
    
    // MARK: - Methods
    func config(diskConfig: DiskConfig) {
        self.limitCount = diskConfig
    }
    
    public func fetch(at url: URL) -> CacheableImage? {
//        DispatchQueue.global().async { [weak self] in
//            guard let self else { return }
//
//            let localPath = self.path(for: url)
//            guard
//                let data = try? QFData(contentsOf: localPath),
//                let decoded = try? JSONDecoder().decode(CacheableImage.self, from: data)
//            else {
//                completion(nil)
//                return
//            }
//            completion(decoded)
//        }
        let localPath = self.path(for: url)
        guard
            let data = try? QFData(contentsOf: localPath),
            let decoded = try? JSONDecoder().decode(CacheableImage.self, from: data)
        else { return nil }
        return decoded
    }
    
    public func save(of cacheableImage: CacheableImage, at url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let localPath = self.path(for: url)
            guard let encoded = try? JSONEncoder().encode(cacheableImage) else { return }
            try? encoded.write(to: localPath)
        }
    }
    
    func path(for url: URL) -> URL {
        let imageName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        
        return cacheURL.appendingPathExtension(imageName)
    }
}

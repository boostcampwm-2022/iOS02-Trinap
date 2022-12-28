//
//  ImageCacheImplements.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public final class DefaultImageCache: ImageCacheProtocol {
    
    // MARK: - Properties
    private let memoryCache = NSCache<NSString, NSData>()
    
    private let diskCache = DiskImageCache()
//    여기서 imageData 하나의 크기까지 지정해주려고 했는데 data 자체의 크기는 크지 않고, image로 바꾸는 연산이 들어가야하므로 빼기로 결정했습니다.
//    private let imageCostLimit: Int
    
    // MARK: Initializers
    init(
        totalCostLimit: Int,
        countLimit: Int
    ) {
        self.config(totalCostLimit: totalCostLimit, countLimit: countLimit)
    }
    
    // MARK: - Methods
    public func fetch(at url: URL, completion: @escaping (QFData?) -> Void) {
        let key = key(for: url)
        
        if let data = memoryCache.object(forKey: key) {
            completion(data as QFData)
        }
        else {
            diskCache.fetch(at: url, completion: { [weak self] fetchedData in
                guard let self, let fetchedData else {
                    completion(nil)
                    return
                }
                self.memoryCache.setObject(fetchedData as NSData, forKey: key) // memoryCache에 저장
                
                completion(fetchedData)
            })
        }
    }
    
    func config(
        totalCostLimit: Int,
        countLimit: Int
    ) {
        memoryCache.countLimit = countLimit
        memoryCache.totalCostLimit = totalCostLimit
    }

    private func key(for url: URL) -> NSString {
        return url.absoluteString as NSString
    }
}

// MARK: 이미지 캐시 로직
extension DefaultImageCache {
    
    private func executeDiskCacheLogic(diskImage: CacheableImage?, url: URL, completion: @escaping (CacheableImage?) -> Void) {
        // 캐시에 값 O
        if let diskImage {
            diskCacheHitted(diskImage: diskImage, url: url) { cacheableImage in
                completion(cacheableImage)
                return
            }
        }
        // 캐시에 값 X
        else {
            diskCacheNotHitted(url: url) { cacheableImage in
                completion(cacheableImage)
                return
            }
        }
        completion(nil)
    }
    
    private func diskCacheHitted(diskImage: CacheableImage, url: URL, completion: @escaping (CacheableImage?) -> Void) {
        self.fetchImage(at: url, etag: diskImage.etag) { [weak self] result in
            switch result {
            case .success(let networkImage): // 데이터 변경되어서 새로운 데이터 받아왔을 경우
                self?.diskCache.save(of: networkImage, at: url)
                self?.memoryCache.save(at: url, of: networkImage)
                completion(networkImage)
                return
            case .failure(let error):
                switch error {
                case .imageNotModifiedError: // disk cache에 있는 데이터가 변경되지 않은 데이터일 경우
                    self?.memoryCache.save(at: url, of: diskImage)
                    completion(diskImage)
                    return
                default:
                    completion(nil)
                }
            }
        }
    }
    
    private func diskCacheNotHitted(url: URL, completion: @escaping (CacheableImage?) -> Void) {
        self.fetchImage(at: url, etag: nil) { [weak self] result in
            switch result {
            case .success(let cacheableImage):
                self?.memoryCache.save(at: url, of: cacheableImage)
                self?.diskCache.save(of: cacheableImage, at: url)
                completion(cacheableImage)
                return
            case .failure:
                completion(nil)
                return
            }
        }
    }
}

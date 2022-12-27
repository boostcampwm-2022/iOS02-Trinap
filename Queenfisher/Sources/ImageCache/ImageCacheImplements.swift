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

public final class DiskImageCache: ImageCacheProtocol {
    
    // MARK: - Properties
    private let fileManager = FileManager.default
    
    private var cacheURL: URL {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Methods
    public func fetch(at url: URL, completion: @escaping (QFData?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            let localPath = self.path(for: url)
            
            if let data = try? QFData(contentsOf: localPath) {
                completion(data)
            } else {
                self.fetchImage(at: url) { fetchedData in
                    guard let fetchedData else {
                        completion(nil)
                        return
                    }
                    self.write(item: fetchedData, at: url) // 받아온 값을 diskCache에 저장
                    
                    try? fetchedData.write(to: localPath)
                    completion(fetchedData)
                }
            }
        }
    }
    
    public func write(item: QFData, at url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let localPath = self.path(for: url)
            
            try? item.write(to: localPath)
        }
    }
    
    func path(for url: URL) -> URL {
        let imageName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        
        return cacheURL.appendingPathExtension(imageName)
    }
}

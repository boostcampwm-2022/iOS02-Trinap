//
//  ImageCacheImplements.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public final class MemoryImageCache: ImageCacheProtocol {
    
    // MARK: - Properties
    private let cache = NSCache<NSString, NSData>()
    
    // MARK: - Methods
    public func fetch(at url: URL, completion: @escaping (QFData?) -> Void) {
        let key = key(for: url)

        if let data = cache.object(forKey: key) {
            completion(data as QFData)
        } else {
            fetchImage(at: url) { [weak self] fetchedData in
                guard let self, let fetchedData else {
                    completion(nil)
                    return
                }
                self.cache.setObject(fetchedData as NSData, forKey: key)
                completion(fetchedData)
            }
        }
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
                    
                    try? fetchedData.write(to: localPath)
                    completion(fetchedData)
                }
            }
        }
    }
    
    func path(for url: URL) -> URL {
        let imageName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        
        return cacheURL.appendingPathExtension(imageName)
    }
}

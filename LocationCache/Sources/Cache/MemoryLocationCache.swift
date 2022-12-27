//
//  MemoryLocationCache.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
import CoreLocation

struct MemoryLocationCache: LocationCacheProtocol {
    
    // MARK: - Properties
    private let cache = NSCache<NSString, NSString>()
    private let diskLocationCache = DiskLocationCache()
    
    // MARK: - Methods
    func reverseGeocodeLocation(_ location: CLLocation, preferredLocale: Locale?, completionHandler: @escaping (String, Error?) -> Void) {
        let key = key(for: location) as NSString
        
        if let address = cache.object(forKey: key) {
            completionHandler(address as String, nil)
            return
        }
        
        diskLocationCache.reverseGeocodeLocation(location, preferredLocale: preferredLocale) { address, error in
            if let error {
                completionHandler(address, error)
                return
            }
            
            cache.setObject(address as NSString, forKey: key)
            
            completionHandler(address, error)
        }
    }
}

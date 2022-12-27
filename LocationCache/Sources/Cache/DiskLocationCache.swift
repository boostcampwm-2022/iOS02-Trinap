//
//  DiskLocationCache.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
import CoreLocation

internal struct DiskLocationCache: LocationCacheProtocol {
    
    // MARK: - Properties
    private let cacheQueue = DispatchQueue(label: "com.tnzkm.disk_location_cache", qos: .userInteractive)
    private let fileManager = FileManager.default
    
    private var cacheURL: URL {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Methods
    func reverseGeocodeLocation(_ location: CLLocation, preferredLocale: Locale?, completionHandler: @escaping (String, Error?) -> Void) {
        cacheQueue.async {
            let key = key(for: location)
            let path = cacheURL.appendingPathExtension("\(key).coord")
            if
                let addressData = try? Data(contentsOf: path),
                let address = String(data: addressData, encoding: .utf8)
            {
                completionHandler(address, nil)
                return
            }
            
            self.fetchLocation(location, preferredLocale: preferredLocale) { placemarks, error in
                guard let address = placemarks?.first?.address else {
                    completionHandler(error?.localizedDescription ?? "", LocationCacheError.noPlacemark)
                    return
                }
                
                try? address.write(to: path, atomically: true, encoding: .utf8)
                
                completionHandler(address, nil)
            }
        }
    }
    
    private func fetchLocation(_ location: CLLocation, preferredLocale: Locale?, _ handler: @escaping CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: preferredLocale, completionHandler: handler)
    }
}

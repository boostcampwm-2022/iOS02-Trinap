//
//  LocationCacheProtocol.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import CoreLocation

internal protocol LocationCacheProtocol {
    
    func reverseGeocodeLocation(_ location: CLLocation, preferredLocale: Locale?, completionHandler: @escaping (String, Error?) -> Void)
    func key(for location: CLLocation) -> String
}

internal extension LocationCacheProtocol {
    
    func key(for location: CLLocation) -> String {
        let latitude = "\(location.coordinate.latitude)".replacingOccurrences(of: ".", with: "_")
        let longitude = "\(location.coordinate.longitude)".replacingOccurrences(of: ".", with: "_")
        
        return "\(latitude)__\(longitude).coord"
    }
}

// MARK: - Cache Instance
internal struct LocationCache {
    
    // MARK: - Properties
    private let memoryLocationCache = MemoryLocationCache()
    
    // MARK: - Singleton
    static let shared = LocationCache()
    private init() {}
    
    // MARK: - Methods
    func reverseGeocodeLocation(_ location: CLLocation, preferredLocale: Locale?, completionHandler: @escaping (String, Error?) -> Void) {
        memoryLocationCache.reverseGeocodeLocation(
            location,
            preferredLocale: preferredLocale,
            completionHandler: completionHandler
        )
    }
}

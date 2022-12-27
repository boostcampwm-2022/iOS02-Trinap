//
//  CLGeocoder+Cache.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import CoreLocation

extension LocationCacheWrapper where Base: CLGeocoder {
    
    public func reverseGeocodeLocation(_ location: CLLocation, preferredLocale: Locale? = nil, completionHandler: @escaping (String, Error?) -> Void) {
        LocationCache.shared.reverseGeocodeLocation(
            location,
            preferredLocale: preferredLocale,
            completionHandler: completionHandler
        )
    }
}

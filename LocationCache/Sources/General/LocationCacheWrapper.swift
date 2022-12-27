//
//  LocationCacheWrapper.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import CoreLocation

public struct LocationCacheWrapper<Base> {
    
    // MARK: - Properties
    public let base: Base
    
    // MARK: - Methods
    public init(base: Base) {
        self.base = base
    }
}

public protocol LocationCacheCompatible: AnyObject {}

public extension LocationCacheCompatible {
    
    var useCache: LocationCacheWrapper<Self> {
        return LocationCacheWrapper(base: self)
    }
}

extension CLGeocoder: LocationCacheCompatible {}

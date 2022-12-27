//
//  CLPlacemark+Address.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    
    var address: String {
        return fullLocationAddress
    }
    
    var fullLocationAddress: String {
        var placemarkData: [String] = []
        
        if let stateArea = subAdministrativeArea?.localizedCapitalized { placemarkData.append(stateArea) }
        if let state = administrativeArea?.localizedCapitalized { placemarkData.append(state) }
        if let city = locality?.localizedCapitalized { placemarkData.append(city) }
        if let subCity = subLocality?.localizedCapitalized { placemarkData.append(subCity) }
        if let street = thoroughfare?.localizedCapitalized { placemarkData.append(street) }
        
        placemarkData.removeDuplicates()
        return placemarkData.joined(separator: " ")
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict: [Element: Bool] = [:]

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

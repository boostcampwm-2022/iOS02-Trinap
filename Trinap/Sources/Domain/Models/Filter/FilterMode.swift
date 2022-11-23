//
//  FilterMode.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum FilterMode: Hashable {
    
    typealias Item = FilterItem
    
    static func == (lhs: FilterMode, rhs: FilterMode) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case photographer
    case reservation
    case main
    
    enum FilterItem: Hashable {
        case photographer(filter: PhotographerFitler)
        case reservation(filter: ReservationFilter)
        case main(filter: TagType)
        
        var title: String {
            switch self {
            case .photographer(filter: let item):
                return item.title
            case .reservation(filter: let item):
                return item.title
            case .main(filter: let item):
                return item.title
            }
        }
    }
    
    var items: [Item] {
        switch self {
        case .photographer:
            return PhotographerFitler.allCases.map {
                FilterItem.photographer(filter: $0)
            }
        case .reservation:
            return ReservationFilter.allCases.map {
                FilterItem.reservation(filter: $0)
            }
        case .main:
            return TagType.allCases.map {
                FilterItem.main(filter: $0)
            }
        }
    }
}

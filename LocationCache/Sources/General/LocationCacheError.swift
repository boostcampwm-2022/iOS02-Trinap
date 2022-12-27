//
//  LocationCacheError.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public enum LocationCacheError: LocalizedError {
    
    case noPlacemark
    
    public var errorDescription: String? {
        switch self {
        case .noPlacemark:
            return "위치 정보를 확인할 수 없습니다."
        }
    }
}

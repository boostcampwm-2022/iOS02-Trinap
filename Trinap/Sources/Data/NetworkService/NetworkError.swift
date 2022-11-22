//
//  NetworkError.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public enum NetworkError: LocalizedError {
    
    case invalidURL
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다."
        case .unknown:
            return "알 수 없는 오류입니다."
        }
    }
}

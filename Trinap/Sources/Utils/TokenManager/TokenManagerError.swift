//
//  TokenManagerError.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum TokenManagerError: LocalizedError {
    
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Cannot find token in TokenManager."
        }
    }
}

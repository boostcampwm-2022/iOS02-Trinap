//
//  FakeError.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum FakeError: LocalizedError {
    
    case unknown
    case errorAt(String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Fake Error"
        case .errorAt(let function):
            return "Error from \(function)"
        }
    }
}

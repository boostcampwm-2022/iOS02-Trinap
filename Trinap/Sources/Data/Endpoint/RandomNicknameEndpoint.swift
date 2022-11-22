//
//  RandomNicknameEndpoint.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum RandomNicknameEndpoint: String, Endpoint {
    case main
    
    var baseURL: URL? { return URL(string: "https://nickname.hwanmoo.kr") }
    
    var method: HTTPMethod { return .GET }
    
    var path: String { return "" }
    
    var parameters: HTTPRequestParameter? { return .query(["format": "json", "count": "1", "max_length": "8"])}
}

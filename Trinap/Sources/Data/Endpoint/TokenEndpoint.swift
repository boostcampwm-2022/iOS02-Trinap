//
//  TokenEndpoint.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum TokenEndpoint: Endpoint {
    case refresh(authorizationCode: String)
    case revoke(refreshToken: String)
    
    var baseURL: URL? {
        return URL(string: "https://us-central1-trinapserver.cloudfunctions.net")
    }
    
    var method: HTTPMethod { return .GET }
    
    var path: String {
        switch self {
        case .refresh:
            return "getRefreshToken"
        case .revoke:
            return "revokeToken"
        }
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .refresh(let authorizationCode):
            return .query(["code": authorizationCode])
        case .revoke(let refreshToken):
            return .query(["refresh_token": refreshToken])
        }
    }
}

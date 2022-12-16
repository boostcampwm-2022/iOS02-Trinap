//
//  OpenSourceInfoDTO.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct OpenSourceInfoDTO: Decodable {
    let identity: String
    let kind: String
    let location: String
    let state: State
    
    struct State: Decodable {
        let revision: String
        let version: String?
        let branch: String?
    }
    
    func toModel() -> OpenSourceInfo {
        return OpenSourceInfo(
            name: self.identity,
            version: self.state.version ?? self.state.branch ?? "master",
            url: URL(string: self.location)
        )
    }
}

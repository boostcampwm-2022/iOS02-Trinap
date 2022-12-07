//
//  SueDTO.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct SueDTO: Codable {

    // MARK: Properties
    let sueId: String
    let suedUserId: String
    let suingUserId: String
    let contents: String
    
    // MARK: Methods
    func toModel() -> Sue {
        return Sue(
            sueId: sueId,
            suedUserId: suedUserId,
            suingUserId: suingUserId,
            contents: contents
        )
    }
}

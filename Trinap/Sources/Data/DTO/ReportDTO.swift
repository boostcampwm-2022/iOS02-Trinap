//
//  ReportDTO.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ReportDTO: Codable {
    
    // MARK: Properties
    let blockId: String
    let blockedUserId: String
    let userId: String
    let status: String
    
    init(blockId: String, blockedUserId: String, userId: String, status: String) {
        self.blockId = blockId
        self.blockedUserId = blockedUserId
        self.userId = userId
        self.status = status
    }
    
}

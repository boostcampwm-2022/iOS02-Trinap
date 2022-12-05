//
//  Block.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Block {
    
    enum BlockStatus: String {
        case active
        case inactive
    }

    // MARK: Properties
    let blockId: String
    let blockedUserId: String
    let userId: String
}

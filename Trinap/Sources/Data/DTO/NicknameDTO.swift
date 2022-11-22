//
//  NicknameDTO.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct NicknameDTO: Decodable {
    
    // MARK: - Properties
    let words: [String]
    let seed: String
}

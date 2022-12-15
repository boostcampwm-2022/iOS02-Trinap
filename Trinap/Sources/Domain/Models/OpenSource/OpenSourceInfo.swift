//
//  OpenSourceInfo.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct OpenSourceInfo: Hashable {
    let name: String
    let version: String
    var url: URL?
}

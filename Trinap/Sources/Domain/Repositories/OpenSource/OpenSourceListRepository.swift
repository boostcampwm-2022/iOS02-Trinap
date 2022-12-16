//
//  OpenSourceListRepository.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

protocol OpenSourceListRepository {
    
    // MARK: - Methods
    func fetchOpenSourceList() -> [OpenSourceInfo]
}

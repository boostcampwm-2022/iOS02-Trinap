//
//  RemoveBlockUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol RemoveBlockUseCase {
    
    // MARK: Methods
    func removeBlockUser(blockId: String) -> Single<Void>
}

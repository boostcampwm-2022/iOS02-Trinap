//
//  CreateBlockUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/03.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateBlockUseCase {

    // MARK: Methods
    func create(blockedUserId: String) -> Single<Void>
    func create(blockedUserId: String, blockId: String) -> Single<Void>
}

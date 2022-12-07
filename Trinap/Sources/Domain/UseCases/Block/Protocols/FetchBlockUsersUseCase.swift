//
//  FetchBlockUsersUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/03.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchBlockUsersUseCase {

    // MARK: Methods
    func fetchBlockUsers() -> Observable<[Block.BlockedUser]>
}

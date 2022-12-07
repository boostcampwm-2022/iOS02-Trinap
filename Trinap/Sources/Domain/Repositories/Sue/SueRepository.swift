//
//  SueRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol SueRepository {

    // MARK: Methods
    func sueUser(suedUserId: String, contents: String) -> Single<Void>
    func fetchSuedUser() -> Single<[Sue]>
}

//
//  UserRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol UserRepository {
    
    // MARK: - Methods
    func fetch() -> Observable<User>
    func fetch(userId: String) -> Observable<User>
    func update(profileImage: URL?, nickname: String?) -> Observable<Void>
}

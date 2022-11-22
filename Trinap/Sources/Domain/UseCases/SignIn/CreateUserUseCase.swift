//
//  CreateUserUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateUserUseCase {
    
    // MARK: - Methods
    func createUser(with nickName: String) -> Observable<Void>
    func createRandomNickname() -> Observable<String>
}

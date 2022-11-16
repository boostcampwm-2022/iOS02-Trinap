//
//  ChatroomRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol ChatroomRepository {
    
    // MARK: - Methods
    func fetch() -> Single<[Chatroom]>
    func create(customerUserId: String, photographerUserId: String) -> Single<Void>
}

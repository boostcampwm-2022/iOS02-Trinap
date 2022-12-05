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
    func observe() -> Observable<[Chatroom]>
    func updateDate(chatroomId: String) -> Observable<Void>
    func create(customerUserId: String, photographerUserId: String) -> Observable<String>
    func create(photographerUserId: String) -> Observable<String>
}

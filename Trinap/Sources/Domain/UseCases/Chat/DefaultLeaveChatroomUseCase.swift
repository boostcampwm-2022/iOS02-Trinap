//
//  DefaultLeaveChatroomUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

final class DefaultLeaveChatroomUseCase: LeaveChatroomUseCase {
    
    // MARK: - Properties
    private let repository: ChatroomRepository
    
    // MARK: - Initializers
    init(repository: ChatroomRepository) {
        self.repository = repository
    }
    
    // MARK: - Methods
    func execute(chatroomId: String) -> Observable<Void> {
        return repository.leave(chatroomId: chatroomId)
            .asObservable()
    }
}

//
//  FakeSueRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct FakeSueRepository: SueRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    
    // MARK: - Initializers
    
    // MARK: - Methods
    func sueUser(suedUserId: String, contents: String) -> Single<Void> {
        return execute(successValue: ()).asSingle()
    }
    
    func fetchSuedUsers() -> Single<[Sue]> {
        var sues: [Sue] = []
        
        for i in 1...Int.random(in: 20...40) {
            sues.append(Sue.stub(sueId: "sueId\(i)"))
        }
        
        return execute(successValue: sues).asSingle()
    }
}

extension Sue {
    
    static func stub(
        sueId: String = UUID().uuidString,
        suedUserId: String = "userId1",
        suingUserId: String = "userId2",
        contents: String = .random
    ) -> Sue {
        return Sue(
            sueId: sueId,
            suedUserId: suedUserId,
            suingUserId: suingUserId,
            contents: contents
        )
    }
}

//
//  MockUserRepository.swift
//  TrinapTests
//
//  Created by Doyun Park on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

@testable import Trinap

final class MockUserRepository: UserRepository {
    
    private let mockUser = User(userId: "", nickname: "", profileImage: nil, isPhotographer: false, fcmToken: "", status: .deactivate)
    
    func fetch() -> Observable<User> {
        return .just(mockUser)
    }
    
    func fetch(userId: String) -> Observable<User> {
        return .just(mockUser)
    }
    
    func fetchUsers(userIds: [String]) -> Observable<[User]> {
        return .just(userIds.isEmpty ? [] : [mockUser])
    }
    
    func update(profileImage: URL?, nickname: String?, isPhotographer: Bool?) -> Observable<Void> {
        return .just(())
    }
}

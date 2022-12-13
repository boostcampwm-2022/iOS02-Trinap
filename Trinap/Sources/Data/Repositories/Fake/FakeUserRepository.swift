//
//  FakeUserRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct FakeUserRepository: UserRepository, FakeRepositoryType {
    // MARK: - Properties
    var isSucceedCase: Bool
    
    // MARK: - Initializers
    init(isSucceedCase: Bool = FakeRepositoryEnvironment.isSucceedCase) {
        self.isSucceedCase = isSucceedCase
    }
    
    // MARK: - Methods
    func fetch() -> Observable<User> {
        return execute(successValue: .fake)
    }
    
    func fetch(userId: String) -> Observable<User> {
        return execute(successValue: .stub(userId: userId))
    }
    
    func fetchUsers(userIds: [String]) -> Observable<[User]> {
        var users: [User] = []
        
        for userId in userIds {
            users.append(.stub(userId: userId))
        }
        
        return execute(successValue: users)
    }
    
    func fetchUsersWithMine(userIds: [String]) -> Observable<[User]> {
        var users: [User] = []
        
        for userId in userIds {
            users.append(.stub(userId: userId))
        }
        
        return execute(successValue: users)
    }
    
    func update(profileImage: String?, nickname: String?, isPhotographer: Bool?) -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func createRandomNickname() -> Observable<String> {
        return execute(successValue: .random)
    }
    
    func updatePhotographerExposure(value: Bool) -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func fetchContact() -> Observable<[Contact]> {
        var contacts: [Contact] = []
        
        for i in 1...Int.random(in: 10...30) {
            contacts.append(.stub(contactId: "contactId\(i)"))
        }
        
        return execute(successValue: contacts)
    }
    
    func fetchDetailContact(contactId: String) -> Observable<Contact> {
        return execute(successValue: .stub(contactId: contactId))
    }
    
    func createContact(title: String, contents: String) -> Observable<Void> {
        return execute(successValue: ())
    }
}

extension User {
    
    static var fake: User {
        return .stub(userId: "userId1")
    }
    
    static func stub(
        userId: String = "userId1",
        nickname: String = "Fake",
        profileImage: URL? = URL(string: "https://user-images.githubusercontent.com/27603734/200277055-fd64e53e-9901-4e8b-893a-1c028264500e.png"),
        isPhotographer: Bool = .random(),
        fcmToken: String = .random,
        status: Status = .activate
    ) -> User {
        return User(
            userId: userId,
            nickname: nickname,
            profileImage: profileImage,
            isPhotographer: isPhotographer,
            fcmToken: fcmToken,
            status: status
        )
    }
}

extension Contact {
    
    static func stub(
        contactId: String = UUID().uuidString,
        title: String = .random,
        description: String = .random,
        createdAt: Date = Date()
    ) -> Contact {
        return Contact(
            contactId: UUID().uuidString,
            title: .random,
            description: .random,
            createdAt: Date().toString(type: .yearAndMonthAndDate)
        )
    }
}

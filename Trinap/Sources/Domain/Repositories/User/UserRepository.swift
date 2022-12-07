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
    func fetchUsers(userIds: [String]) -> Observable<[User]>
    func fetchUsersWithMine(userIds: [String]) -> Observable<[User]>
    func update(profileImage: String?, nickname: String?, isPhotographer: Bool?) -> Observable<Void>
    func createRandomNickname() -> Observable<String>
    func fetchContact() -> Observable<[Contact]>
    func fetchDetailContact(contactId: String) -> Observable<Contact>
    func createContact(title: String, contents: String) -> Observable<Void>
}

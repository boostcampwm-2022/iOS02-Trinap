//
//  FetchContactUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchContactUseCase {
    func fetchContacts() -> Observable<[Contact]>
    func fetchDetailContact(contactId: String) -> Observable<Contact>
}

final class DefaultFetchContactUseCase: FetchContactUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchContacts() -> Observable<[Contact]> {
        return userRepository.fetchContact()
    }
    
    func fetchDetailContact(contactId: String) -> Observable<Contact> {
        return userRepository.fetchDetailContact(contactId: contactId)
    }
}

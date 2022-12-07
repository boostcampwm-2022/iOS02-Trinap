//
//  CreateContactUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateContactUseCase {
    func create(title: String, contents: String) -> Observable<Void>
}

final class DefaultCreateContactUseCase: CreateContactUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func create(title: String, contents: String) -> Observable<Void> {
        return userRepository.createContact(title: title, contents: contents)
    }
}

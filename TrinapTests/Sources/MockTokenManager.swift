//
//  MockTokenManager.swift
//  TrinapTests
//
//  Created by 김세영 on 2022/11/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

@testable import Trinap

final class MockSucceedTokenManager: TokenManager {
    
    // MARK: - Properties
    var token: Token
    
    // MARK: - Initializers
    init(token: Token = "token") {
        self.token = token
    }
    
    // MARK: - Methods
    func getToken(with key: KeychainAccount = .userId) -> Token? {
        return token
    }
    
    func save(token: Token, with key: KeychainAccount = .userId) -> Bool {
        self.token = token
        return true
    }
    
    func deleteToken(with key: KeychainAccount = .userId) -> Bool {
        self.token = ""
        return true
    }
}

final class MockFailureTokenManager: TokenManager {
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    // MARK: - Methods
    func getToken(with key: KeychainAccount = .userId) -> Token? {
        return nil
    }
    
    func save(token: Token, with key: KeychainAccount = .userId) -> Bool {
        return false
    }
    
    func deleteToken(with key: KeychainAccount = .userId) -> Bool {
        return false
    }
}

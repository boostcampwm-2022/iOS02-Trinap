//
//  KeychainTokenManager.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class KeychainTokenManager: TokenManager {
    
    private let keychainAccount = "com.tnzkm.keychain"
    private let securityClass = kSecClassGenericPassword
    
    func getToken() -> Token? {
        let query: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: keychainAccount,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else { return nil }
        
        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecValueData as String] as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    func save(token: Token) -> Bool {
        guard let tokenData = token.data(using: .utf8) else { return false }
        
        let saveQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: keychainAccount,
            kSecValueData: tokenData
        ]
        
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(tokenData: tokenData)
        } else {
            return false
        }
    }
    
    private func update(tokenData: Data) -> Bool {
        let updateQuery: [CFString: Any] = [kSecValueData: tokenData]
        let searchQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: keychainAccount
        ]
        
        let status = SecItemUpdate(searchQuery as CFDictionary, updateQuery as CFDictionary)
        
        return status == errSecSuccess
    }
    
    func deleteToken() -> Bool {
        let searchQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: keychainAccount
        ]
        
        let status = SecItemDelete(searchQuery as CFDictionary)
        
        return status == errSecSuccess
    }
}

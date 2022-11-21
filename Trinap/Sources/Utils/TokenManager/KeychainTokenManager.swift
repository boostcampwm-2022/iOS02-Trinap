//
//  KeychainTokenManager.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class KeychainTokenManager: TokenManager {
    
    // MARK: - Properties
    private let securityClass = kSecClassGenericPassword
    
    // MARK: - Methods
    func getToken(with key: KeychainAccount) -> Token? {
        let query: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            logStatus(status)
            return nil
        }
        
        guard
            let existingItem = item as? [String: Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let token = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        
        return token
    }
    
    func save(token: Token, with key: KeychainAccount) -> Bool {
        guard let tokenData = token.data(using: .utf8) else { return false }
        
        let saveQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue,
            kSecValueData: tokenData
        ]
        
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(tokenData: tokenData, with: key)
        } else {
            logStatus(status)
            return false
        }
    }
    
    private func update(tokenData: Data, with key: KeychainAccount) -> Bool {
        let updateQuery: [CFString: Any] = [kSecValueData: tokenData]
        let searchQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemUpdate(searchQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            logStatus(status)
            return false
        }
    }
    
    func deleteToken(with key: KeychainAccount) -> Bool {
        let searchQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(searchQuery as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            logStatus(status)
            return false
        }
    }
    
    private func logStatus(_ status: OSStatus) {
        let description = SecCopyErrorMessageString(status, nil)
        Logger.print(description ?? "Unknown error detected at Keychain.")
    }
}

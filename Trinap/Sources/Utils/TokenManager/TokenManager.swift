//
//  TokenManager.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

typealias Token = String

protocol TokenManager {
    
    /// `TokenManager`에 `key`로 저장되어 있는 토큰을 반환합니다.
    /// - Returns: 토큰이 저장되어 있으면 토큰을, 없으면 `nil`을 반환합니다.
    func getToken(with key: KeychainAccount) -> Token?
    
    /// `TokenManager`에 `key`에 해당하는 토큰을 저장 및 업데이트합니다.
    /// - Returns: 토큰 저장에 성공하면 `true`를, 실패하면 `false`를 반환합니다.
    @discardableResult
    func save(token: Token, with key: KeychainAccount) -> Bool
    
    /// `TokenManager`에서 `key`에 해당하는 토큰을 삭제합니다.
    /// - Returns: 토큰이 존재하지 않거나 삭제에 성공한 경우 `true`를, 실패하면 `false`를 반환합니다.
    @discardableResult
    func deleteToken(with key: KeychainAccount) -> Bool
}

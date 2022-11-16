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
    
    /// `TokenService`에 저장되어 있는 토큰을 반환합니다.
    /// - Returns: 토큰이 저장되어 있으면 토큰을, 없으면 `nil`을 반환합니다.
    func getToken() -> Token?
    
    /// `TokenService`에 토큰을 저장 및 업데이트합니다.
    /// - Returns: 토큰 저장에 성공하면 `true`를, 실패하면 `false`를 반환합니다.
    @discardableResult
    func save(token: Token) -> Bool
    
    /// `TokenService`에서 토큰을 삭제합니다.
    /// - Returns: 토큰이 존재하지 않거나 삭제에 성공한 경우 `true`를, 실패하면 `false`를 반환합니다.
    @discardableResult
    func deleteToken() -> Bool
}

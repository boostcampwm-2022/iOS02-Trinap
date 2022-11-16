//
//  UserDTO.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct UserDTO: Codable {
    
    enum Status: String, Codable {
        case activate, deactivate
    }
    
    // MARK: - Properties
    let userId: String
    let nickname: String
    let profileImage: String
    let isPhotographer: Bool
    let fcmToken: String
    let status: Status
    
    // MARK: - Methods
    func toModel() -> User {
        return User(
            userId: userId,
            nickname: nickname,
            profileImage: URL(string: profileImage),
            isPhotographer: isPhotographer,
            fcmToken: fcmToken,
            status: status
        )
    }
}

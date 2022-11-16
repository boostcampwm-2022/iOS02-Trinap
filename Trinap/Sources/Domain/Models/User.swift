//
//  User.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct User {
    
    // MARK: - Properties
    let userId: String
    let nickname: String
    let profileImage: URL?
    let isPhotographer: Bool
    let fcmToken: String
    let status: UserDTO.Status
}

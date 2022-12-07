//
//  KeychainAccount.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum KeychainAccount: String {
    case userId = "com.tnzkm.keychain.userId"
    case fcmToken = "com.tnzkm.keychain.fcmToken"
    case refreshToken = "com.tnzkm.keychain.refreshToken"
}

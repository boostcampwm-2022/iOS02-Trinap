//
//  String+.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import CryptoKit
import Foundation

extension String {
    
    func toSha256() -> String {
        let data = Data(self.utf8)
        let hashedData = SHA256.hash(data: data)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
            
        return hashString
    }
}

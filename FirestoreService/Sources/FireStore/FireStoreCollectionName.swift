//
//  FireStoreCollectionName.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public enum FireStoreCollection: String {
    case blocks, chatrooms, photographers, reservations, reviews, users, chats, locations
    
    var name: String {
        return self.rawValue
    }
}

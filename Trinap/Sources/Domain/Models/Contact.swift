//
//  ContactUs.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Contact: Hashable {
    enum State: String, Codable {
        case activate, deactivate
    }
    
    let contactId: String
    let title: String
    let description: String
    let createdAt: String
}

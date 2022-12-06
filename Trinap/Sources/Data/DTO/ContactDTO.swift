//
//  ContactUsDTO.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ContactDTO: Codable {
    let contactId: String
    let userId: String
    let title: String
    let description: String
    let createAt: String
    let status: Contact.State
    
    func toModel() -> Contact {
        return Contact(
            contactId: self.contactId,
            title: self.title,
            description: self.description,
            createdAt: self.createAt
        )
    }
}

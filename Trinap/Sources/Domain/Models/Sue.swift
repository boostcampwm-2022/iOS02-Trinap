//
//  Sue.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct Sue {

    // MARK: Properties
    let sueId: String
    let suedUserId: String
    let suingUserId: String
    let contents: SueContents
    
    //MARK: Initializer
    init(sueId: String, suedUserId: String, suingUserId: String, contents: SueContents) {
        self.sueId = sueId
        self.suedUserId = suedUserId
        self.suingUserId = suingUserId
        self.contents = contents
    }
    
    init(sueId: String, suedUserId: String, suingUserId: String, contents: String) {
        self.sueId = sueId
        self.suedUserId = suedUserId
        self.suingUserId = suingUserId
        switch contents {
        case "욕설, 비방":
            self.contents = .blame
        case "혐오 발언":
            self.contents = .hateSpeech
        case "불쾌감을 주거나 부적절한 이름 사용":
            self.contents = .annoyance
        default:
            self.contents = .etc(contents)
        }
    }
}


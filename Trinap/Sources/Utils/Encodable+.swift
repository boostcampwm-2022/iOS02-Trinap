//
//  Encodable+.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
extension Encodable {
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
            let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any]
        else { return nil }
        return dictinoary
    }
}

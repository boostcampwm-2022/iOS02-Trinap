//
//  Dictionary+.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

extension Dictionary<String, Any> {
    
    func toObject<T>() -> T? where T: Decodable {
        guard
            let data = try? JSONSerialization.data(withJSONObject: self),
            let object = try? JSONDecoder().decode(T.self, from: data)
        else {
            return nil
        }
        
        return object
    }
    
    func toObject<T>(type: T.Type) -> T? where T: Decodable {
        return self.toObject()
    }
}

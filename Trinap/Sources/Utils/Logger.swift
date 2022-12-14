//
//  Logger.swift
//  Trinap
//
//  Created by κΉμΈμ on 2022/11/15.
//  Copyright Β© 2022 Trinap. All rights reserved.
//

import Foundation

enum Logger {
    
    static func print(_ items: Any, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        Swift.print()
        Swift.print("π’ Log at \(file.components(separatedBy: "/").last ?? "Some File")")
        Swift.print("π’ function: \(function), line: \(line)")
        Swift.print("π’")
        Swift.print("π’", items)
        Swift.print()
        #endif
    }
    
    static func printArray(_ array: [Any], file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        Swift.print()
        Swift.print("π’ Log at \(file.components(separatedBy: "/").last ?? "Some File")")
        Swift.print("π’ function: \(function), line: \(line)")
        Swift.print("π’")
        for item in array {
            Swift.print("π’", item)
        }
        Swift.print()
        #endif
    }
}

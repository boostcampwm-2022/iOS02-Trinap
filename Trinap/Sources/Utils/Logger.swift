//
//  Logger.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

#if DEBUG
final class Logger {
    
    static func print(_ items: Any, file: String = #file, function: String = #function, line: Int = #line) {
        Swift.print()
        Swift.print("🟢 Log at \(file.components(separatedBy: "/").last ?? "Some File")")
        Swift.print("🟢 function: \(function), line: \(line)")
        Swift.print("🟢")
        Swift.print("🟢", items)
        Swift.print()
    }
}
#endif

//
//  Than.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

public protocol Than {}

extension Than where Self: Any {
    
    /// Value Type의 인스턴스를 생성한 후 `apply`을 통해 여러 설정을 진행합니다.
    /// - Parameter apply: 설정을 진행할 클로저입니다.
    /// - Returns: `apply`의 설정이 반영된 인스턴스를 반환합니다.
    public func configure(_ apply: (inout Self) throws -> Void) rethrows -> Self {
        var mutableSelf = self
        
        try apply(&mutableSelf)
        return mutableSelf
    }
}

extension Than where Self: AnyObject {
    
    /// 인스턴스를 생성한 후 `apply`를 통해 설정을 진행합니다.
    /// - Parameter apply: 설정을 진행할 클로저입니다.
    /// - Returns: `apply`의 설정이 반영된 인스턴스를 반환합니다.
    public func than(_ apply: (Self) throws -> Void) rethrows -> Self {
        try apply(self)
        return self
    }
}

extension NSObject: Than {}

extension CGPoint: Than {}
extension CGRect: Than {}
extension CGSize: Than {}

extension Array: Than {}
extension Dictionary: Than {}
extension Set: Than {}

extension UIEdgeInsets: Than {}
extension UIOffset: Than {}
extension UIRectEdge: Than {}

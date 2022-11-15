//
//  Queenfisher.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

public typealias QFImage = UIImage
public typealias QFImageView = UIImageView
public typealias QFButton = UIButton
public typealias QFIndicator = UIActivityIndicatorView
public typealias QFData = Data

/// Queenfisher compatible types의 Wrapper입니다.
/// `qf` 메서드를 제공합니다.
public struct QueenfisherWrapper<Base> {
    
    // MARK: - Properties
    public let base: Base
    
    // MARK: - Methods
    public init(base: Base) {
        self.base = base
    }
}

/// Object 타입을 위한 Queenfisher namespace입니다.
public protocol QueenfisherCompatible: AnyObject {}

extension QueenfisherCompatible {
    
    /// `QueenfisherCompatible` namespace입니다.
    public var qf: QueenfisherWrapper<Self> {
        get { return QueenfisherWrapper(base: self) }
    }
}

// MARK: - Conforms Queenfisher Compatible
extension QFImage: QueenfisherCompatible {}
extension QFImageView: QueenfisherCompatible {}
extension QFButton: QueenfisherCompatible {}

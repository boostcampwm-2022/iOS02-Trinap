//
//  UICollectionView+Reusable.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T>(_ cellClass: T.Type) where T: UICollectionReusableView {
        self.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
}

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

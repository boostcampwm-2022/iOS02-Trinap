//
//  UICollectionView+Reusable.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T>(_ cellClass: T.Type) where T: UICollectionViewCell {
        self.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func registerReusableView<T>(_ cellClass: T.Type) where T: UICollectionReusableView {
        self.register(
            cellClass.self,
            forSupplementaryViewOfKind: cellClass.reuseIdentifier,
            withReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
    
    func dequeResuableView<T>(_ viewClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(ofKind: viewClass.reuseIdentifier, withReuseIdentifier: viewClass.reuseIdentifier, for: indexPath) as? T
    }
}

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

//
//  RxSwift+CollectionViewDataSource.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UICollectionView {
    
    public func itemSelected<Section, Item>(
        at dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    ) -> Observable<Item> {
        return delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { object in
                return try castOrThrow(IndexPath.self, object[1])
            }
            .compactMap { indexPath in
                return dataSource?.itemIdentifier(for: indexPath)
            }
    }
    
    public func itemDeselected<Section, Item>(
        at dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    ) -> Observable<Item> {
        return delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didDeselectItemAt:)))
            .compactMap { object in
                return try castOrThrow(IndexPath.self, object[1])
            }
            .compactMap { indexPath in
                return dataSource?.itemIdentifier(for: indexPath)
            }
    }
    
    private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }
}

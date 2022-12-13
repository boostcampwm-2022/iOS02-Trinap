//
//  PhotographerDetailDataSource.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import SkeletonView

class PhotographerListSkeletonDiffableDataSource<Section: Hashable, Item: Hashable>:
    UICollectionViewDiffableDataSource<Section, Item> {
    
    override init(collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<Section, Item>.CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
}

extension PhotographerListSkeletonDiffableDataSource: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return PhotographerPreviewCell.reuseIdentifier
    }
}

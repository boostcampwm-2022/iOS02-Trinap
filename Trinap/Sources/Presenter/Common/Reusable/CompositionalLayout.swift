//
//  CompositionalLayout.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/09.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

enum CompositionalLayout {
    
    enum CompositionalGroupAlignment {
        case vertical
        case horizontal
    }
    
    static func createItem(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        inset: NSDirectionalEdgeInsets = .zero
    ) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: width,
                heightDimension: height)
        )
        item.contentInsets = inset
        return item
    }
    
    static func createGroup(
        alignment: CompositionalGroupAlignment,
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        items: [NSCollectionLayoutItem]
    ) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height),
                subitems: items
            )
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height),
                subitems: items
            )
        }
    }
    
    static func createGroup(
        alignment: CompositionalGroupAlignment,
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        item: NSCollectionLayoutItem,
        count: Int
    ) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height),
                subitem: item,
                count: count
            )
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height),
                subitem: item,
                count: count
            )
        }
    }
    
    static func createBoundarySupplementaryItem(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        kind: String,
        alignment: NSRectAlignment
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: width,
                heightDimension: height
            ),
            elementKind: kind,
            alignment: alignment)
    }
}

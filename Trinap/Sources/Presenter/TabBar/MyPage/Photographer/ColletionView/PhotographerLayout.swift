//
//  PhotographerLayout.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/10.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

enum PhotographerLayout: Int, CaseIterable {
    
    case portfolio = 0
    case detail
    case review
    
    /// offset 기본 단위
    var trinapOffset: CGFloat {
        return UIScreen.main.bounds.width / 50
    }
    
    func createLayout(index: Int, isEditable: Bool? = nil) -> NSCollectionLayoutSection {
        switch self {
        case .portfolio:
            guard let isEditable else {
                return index == 0 ? self.generateProfileLayout() : self.generatePhotoLayout()
            }
            return index == 0 ? self.generateProfileLayout() : self.generatePhotoLayout(isEditable: isEditable)
        case .detail:
            return index == 0 ? self.generateProfileLayout() : self.generateDetailLayout()
        case .review:
            let isProfile = index == 0
            return isProfile ? generateProfileLayout() : index == 1 ? generateReviewRatingLayout() : generateReviewLayout()
        }
    }

    /// 작가 프로필 ~ 필터포함
    private func generateProfileLayout() -> NSCollectionLayoutSection {
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .fractionalWidth(1.0),
            height: .estimated(trinapOffset * 23),
            items: [item]
        )
        return NSCollectionLayoutSection(group: group)
    }
    
    /// 사진 수정모드
    private func generatePhotoLayout(isEditable: Bool) -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1.0),
            height: .fractionalHeight(1.0),
            inset: NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        )
        
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .fractionalWidth(1.0),
            height: .fractionalWidth(1 / 3),
            item: item,
            count: 3
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let header = CompositionalLayout.createBoundarySupplementaryItem(
            width: .fractionalWidth(1.0),
            height: .absolute(32),
            kind: isEditable ? EditPhotographerPhotoDeleteHeaderView.reuseIdentifier : EditPhotographerPhotoHeaderView.reuseIdentifier,
            alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 6, bottom: 0, trailing: 6)
        return section
    }
    
    /// 사진들 단순 보기
    private func generatePhotoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1 / 3)
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        return section
    }
    
    /// 상세 정보 레이아웃
    private func generateDetailLayout() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        
        let group = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(1.0),
            height: .estimated(trinapOffset * 40),
            items: [item]
        )

        let offset = trinapOffset * 2
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section
    }
    
    private func generateReviewRatingLayout() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        
        let group = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(1.0),
            height: .estimated(trinapOffset * 8),
            items: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    private func generateReviewLayout() -> NSCollectionLayoutSection {
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .estimated(trinapOffset * 13))
        
        let group = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(1.0),
            height: .estimated(trinapOffset * 13),
            items: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 32
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16)
        return section
    }
}

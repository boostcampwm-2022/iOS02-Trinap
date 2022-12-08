//
//  ThumbnailCollectionView.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/08.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than

final class ThumbnailCollectionView: BaseView {
    
    // MARK: UI
    private lazy var layout = UICollectionViewFlowLayout().than {
        $0.itemSize = CGSize(width: self.frame.width, height: self.frame.height)
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).than {
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.clipsToBounds = true
        $0.alwaysBounceHorizontal = true
        $0.showsHorizontalScrollIndicator = false
        $0.layer.cornerRadius = 20
    }
    
    private lazy var thumbnailPageControl = UIPageControl().than {
        $0.isUserInteractionEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Properties
    private var urlStrings: [String] = []
    
    private var dataSource: DataSource?
    
    // MARK: Initializers
    
    // MARK: Methods
    override func configureHierarchy() {
        self.addSubviews([
            collectionView,
            thumbnailPageControl
        ])
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbnailPageControl.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView.snp.bottom)
            make.centerX.equalTo(collectionView)
        }
    }
    
    override func configureAttributes() {
        configureCollectionView()
        self.dataSource = generateDataSource()
    }
    
    override func bind() {}
    
    func configure(urlStrings: [String]) {
        thumbnailPageControl.numberOfPages = urlStrings.count
        let snaphot = generateSnapshot(imageStrings: urlStrings)
        dataSource?.apply(snaphot)
    }
}

extension ThumbnailCollectionView: UICollectionViewDelegateFlowLayout {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    
    private func configureCollectionView() {
        self.collectionView.register(ThumbnailCollectionViewCell.self)
        self.collectionView.allowsSelection = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
    }
    
    private func generateDataSource() -> DataSource {
        return DataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueCell(ThumbnailCollectionViewCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            cell.configure(imageString: itemIdentifier)
            return cell
        }
    }
    
    private func generateSnapshot(imageStrings: [String]) -> NSDiffableDataSourceSnapshot<Section, String> {
        var snapShot = NSDiffableDataSourceSnapshot<Section, String>()
        snapShot.appendSections([.main])
        snapShot.appendItems(imageStrings, toSection: .main)
        return snapShot
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        let height = self.frame.height
        return CGSize(width: width, height: height)
    }
}

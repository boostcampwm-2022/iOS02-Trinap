//
//  FilterTabbarCollectionViewAdapter.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class FilterView: UICollectionView, UICollectionViewDelegate {
    
    private var filterMode: FilterMode
    private var disposeBag = DisposeBag()
    
    private var filterDataSource: UICollectionViewDiffableDataSource<Int, FilterMode.Item>?
    
    private let underlineView = UIView().than {
        $0.backgroundColor = .black
    }
    
    init(filterMode: FilterMode) {
        self.filterMode = filterMode
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        configureCollectionView()
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionViewLayout = layout
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        
        let snapshot = generateSnapshot(self.filterMode)
        
        self.register(FilterCell.self)
        self.filterDataSource = generateDataSource()
        self.filterDataSource?.apply(snapshot)
        self.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func configureUI() {
        self.backgroundColor = TrinapAsset.white.color
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.1

        self.addSubview(underlineView)
    }
    
    private func generateDataSource() -> UICollectionViewDiffableDataSource<Int, FilterMode.Item> {
        return UICollectionViewDiffableDataSource(collectionView: self) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueCell(FilterCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(title: itemIdentifier.title)
            return cell
        }
    }
    
    private func generateSnapshot(_ filterMode: FilterMode) -> NSDiffableDataSourceSnapshot<Int, FilterMode.FilterItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FilterMode.FilterItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(filterMode.items, toSection: 0)
        return snapshot
    }
    
    private func bind() {
        self.rx.itemSelected
            .compactMap { [weak self] indexPath in
                return self?.cellForItem(at: indexPath)
            }
            .subscribe(onNext: { [weak self] cell in
                guard let self else { return }
                
                let xPosition = cell.frame.origin.x
                let width = cell.frame.width
                
                self.updateView(xPosition: xPosition, width: width)
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateView(xPosition: CGFloat, width: CGFloat) {
        self.underlineView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(xPosition)
            make.width.equalTo(width)
            make.bottom.equalToSuperview().offset(trinapOffset * 6)
            make.height.equalTo(2)
        }
    }
}

// MARK: - Layout
extension FilterView: UICollectionViewDelegateFlowLayout {
    
    private func configureCollectionViewLoyout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell = collectionView.dequeueCell(FilterCell.self, for: indexPath),
        let data = self.filterDataSource?.itemIdentifier(for: indexPath)
        else {
            return .zero
        }

        let size = cell.sizeFittingWith(cellHeight: trinapOffset * 6, text: data.title)
        
        if indexPath.row == 0 {
            underlineView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(size.width)
                make.height.equalTo(2)
                make.bottom.equalToSuperview().offset(trinapOffset * 6)
            }
        }
        return size
    }
}

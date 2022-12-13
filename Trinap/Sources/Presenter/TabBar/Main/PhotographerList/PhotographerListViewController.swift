//
//  PhotographerListViewController.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit

final class PhotographerListViewController: BaseViewController {

    // MARK: - UI
    private lazy var searchBarView = SearchBarView()
    
    private lazy var filterView = FilterView(filterMode: .main)
    
    private lazy var layout = UICollectionViewFlowLayout().than {
        let width = self.view.frame.width - (2 * trinapOffset)
//        let height = 300.0
        let height = 0.8 * width
        $0.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        $0.minimumLineSpacing = 24
        $0.estimatedItemSize = CGSize(width: width, height: height)
        $0.scrollDirection = .vertical
    }
        
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).than {
        $0.allowsSelection = false
        $0.register(PhotographerPreviewCell.self)
        $0.backgroundColor = TrinapAsset.white.color
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotographerPreview>?
    
    // MARK: - Properties
    private let viewModel: PhotographerListViewModel
    
    // MARK: - Initializers
    init(viewModel: PhotographerListViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        
        collectionView.isSkeletonable = true
        collectionView.showSkeleton()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            filterView,
            collectionView
        ])
    }

    override func configureConstraints() {
        filterView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(filterView.snp.bottom).offset(2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    override func configureAttributes() {
        dataSource = configureDataSource()
    }

    override func bind() {
        viewModel.searchText
            .map { [weak self] text in
                if text.isEmpty {
                    self?.searchBarView.searchLabel.textColor = TrinapAsset.gray40.color
                    return self?.viewModel.defaultString
                }
                self?.searchBarView.searchLabel.textColor = .black
                return text
            }
            .bind(to: searchBarView.searchLabel.rx.text)
            .disposed(by: disposeBag)
        
        let type = self.filterView.rx.itemSelected
            .map { TagType(index: $0.row) }
        
        let searchTrigger = searchBarView.rx.tapGesture()
            .when(.recognized)
            .asObservable()
            .map { _ in }
                
        let input = PhotographerListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            searchTrigger: searchTrigger,
            tagType: type
        )
        
        let output = viewModel.transform(input: input)
        
        output.previews
            .compactMap { [weak self] previews in
                self?.generateSnapshot(sources: previews)
            }
            .drive(onNext: { [weak self] snapshot in
                self?.collectionView.hideSkeleton()
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
}

extension PhotographerListViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    func generateSnapshot(sources: [PhotographerPreview]) -> NSDiffableDataSourceSnapshot<Section, PhotographerPreview> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotographerPreview>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(sources)
        return snapshot
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, PhotographerPreview> {
        return PhotographerListSkeletonDiffableDataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueCell(PhotographerPreviewCell.self, for: indexPath)
            else { return UICollectionViewCell() }
            
            cell.configureCell(itemIdentifier)
            
            cell.rx.tapGesture()
                .asObservable()
                .when(.recognized)
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.viewModel.showDetailPhotographer(userId: itemIdentifier.photographerUserId)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
}

// MARK: - Privates
private extension PhotographerListViewController {
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        
        self.navigationItem.titleView = searchBarView
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
    }
}

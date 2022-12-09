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
        let height = width * 0.8
        $0.minimumLineSpacing = 10
        $0.estimatedItemSize = CGSize(width: width, height: height)
        $0.scrollDirection = .vertical
    }
        
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).than {
        $0.allowsSelection = false
        $0.register(PhotographerPreviewCell.self)
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
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            searchBarView,
            filterView,
            collectionView
        ])
    }

    override func configureConstraints() {
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(trinapOffset)
            make.trailing.equalToSuperview().offset(-trinapOffset)
            make.height.equalTo(48)
        }
        
        filterView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchBarView.snp.bottom)
            make.height.equalTo(trinapOffset * 6)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(filterView.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
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
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
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

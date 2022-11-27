//
//  PhotographerListViewController.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class PhotographerListViewController: BaseViewController {

    // MARK: - UI
    //TODO: 디자인이 다르고 입력받을 일이 없어서 uiview로 변경하기
    private lazy var searchBar = UISearchBar().than {
        $0.setImage(UIImage(named: "icSearchNonW"), for: UISearchBar.Icon.search, state: .normal)
        $0.placeholder = "추억을 만들 장소를 선택해주세요."
    }
    
    private lazy var filterView = FilterView(filterMode: .main)
    
    private lazy var layout = UICollectionViewFlowLayout().than {
        let width = self.view.frame.width - (2 * trinapOffset)
        let height = width * 0.8
        $0.minimumLineSpacing = 10
        $0.estimatedItemSize = CGSize(width: width, height: height)
        $0.scrollDirection = .vertical
    }
        
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).than {
        $0.register(PhotographerPreviewCell.self)
    }
    
    private var datasource: UICollectionViewDiffableDataSource<Section, PhotographerPreview>?
    
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
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }

    override func configureHierarchy() {
        self.view.addSubviews([
            searchBar,
            filterView,
            collectionView
        ])
    }

    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        filterView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(trinapOffset)
            make.trailing.equalToSuperview().offset(-trinapOffset)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(trinapOffset)
            make.trailing.equalToSuperview().offset(-trinapOffset)
            make.top.equalTo(filterView.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
        }
    }

    override func configureAttributes() {
        searchBar.isUserInteractionEnabled = false
        datasource = configureDataSource()
    }

    override func bind() {
        
        viewModel.searchText.bind(to: searchBar.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        let type = self.filterView.rx.itemSelected
            .map { TagType(index: $0.row) }
        let searchTrigger = searchBar.rx.tapGesture()
            .when(.recognized).asObservable()
            .map { _ in return () }
        
        //TODO: 선택된 셀 인덱스로 넘겨주기
        
        let input = PhotographerListViewModel.Input(
            searchTrigger: searchTrigger,
            tagType: type
        )
        
        let output = viewModel.transform(input: input)
        
        output.previews
            .compactMap { [weak self] previews in
                //TODO: 값이 빈 배열이 넘어오면 실행되지 않음,,,,,,,
                Logger.print("쨔스")
                Logger.printArray(previews)
                return self?.generateSnapshot(sources: previews)
            }
            .drive(onNext: { [weak self] snapshot in
                self?.datasource?.apply(snapshot, animatingDifferences: true)
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
            return cell
        }
    }

}

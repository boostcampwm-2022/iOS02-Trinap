//
//  SearchViewController.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

final class SearchViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var searchBar = UISearchBar().than {
        $0.setImage(UIImage(named: "icSearchNonW"), for: UISearchBar.Icon.search, state: .normal)
        $0.placeholder = "장소를 입력해주세요"
    }
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self)
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Space>?

    // MARK: - Properties
    private let viewModel: SearchViewModel
    // TODO: 얘 weak? 안 weak?
    private weak var searchText: BehaviorRelay<String>?
    
    // MARK: - Initializers
    init(
        viewModel: SearchViewModel,
        searchText: BehaviorRelay<String>
    ) {
        self.viewModel = viewModel
        self.searchText = searchText
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([searchBar, searchTableView])
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        searchTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        dataSource = configureDataSource()
    }
    
    override func bind() {
        
        searchText?
            .bind(to: searchBar.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        let selectedSpace = searchTableView.rx.itemSelected
            .asObservable()
            .map { [weak self] index -> Space? in
                self?.dataSource?.itemIdentifier(for: index)
            }
            .compactMap{ $0 }

        selectedSpace
            .map { $0.name }
            .bind(to: searchText ?? BehaviorRelay<String>(value: ""))
            .disposed(by: disposeBag)
        
        let input = SearchViewModel.Input(
            searchText: searchBar.rx.text.orEmpty.asObservable(),
            selectedSpace: selectedSpace
        )
        
        let output = viewModel.transform(input: input)

        output.spaces
            .compactMap { [weak self] spaces in
                self?.generateSnapshot(sources: spaces)
            }
            .drive { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView DiffableDataSource
extension SearchViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    func generateSnapshot(sources: [Space]) -> NSDiffableDataSourceSnapshot<Section, Space> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Space>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(sources)
        return snapshot
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Space> {
        return UITableViewDiffableDataSource(
            tableView: searchTableView
        ) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
            else { return UITableViewCell() }
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.name
            cell.contentConfiguration = content
            return cell
        }
    }
}

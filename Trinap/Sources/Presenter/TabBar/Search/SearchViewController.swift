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
        $0.searchTextField.layer.cornerRadius = 20
        $0.searchTextField.layer.masksToBounds = true
        $0.setImage(nil, for: UISearchBar.Icon.search, state: .normal)
        $0.placeholder = "장소를 입력해주세요"
    }
    
    private lazy var currentLocationButton = TrinapButton(style: .secondary).than {
        $0.setTitle("현재 위치", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
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

    
    // MARK: - Initializers
    init(
        viewModel: SearchViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            searchBar,
            currentLocationButton,
            searchTableView
        ])
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(trinapOffset)
            make.trailing.equalToSuperview().offset(-trinapOffset)
            make.height.equalTo(36)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(currentLocationButton.snp.bottom)
        }
    }
    
    override func configureAttributes() {
        dataSource = configureDataSource()
    }
    
    override func bind() {
        
        viewModel.searchText?
            .bind(to: searchBar.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        let selectedSpace = searchTableView.rx.itemSelected
            .asObservable()
            .map { [weak self] index -> Space? in
                self?.dataSource?.itemIdentifier(for: index)
            }
            .compactMap { $0 }

        selectedSpace
            .map { $0.name }
            .bind(to: viewModel.searchText ?? BehaviorRelay<String>(value: ""))
            .disposed(by: disposeBag)
        
        let input = SearchViewModel.Input(
            searchText: searchBar.rx.text.orEmpty.asObservable(),
            selectedSpace: selectedSpace,
            currentLocationTrigger: currentLocationButton.rx.tap.asObservable()
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
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
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

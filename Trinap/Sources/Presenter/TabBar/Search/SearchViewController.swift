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
    private lazy var searchBar = TrinapSearchBar()
    
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        configureNavigationBar()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            currentLocationButton,
            searchTableView
        ])
    }
    
    override func configureConstraints() {
        currentLocationButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
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
            .bind(to: searchBar.textField.rx.text)
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
            searchText: searchBar.textField.rx.text.orEmpty.asObservable(),
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

// MARK: - Privates
private extension SearchViewController {
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let backButtonImage = UIImage(systemName: "arrow.left")?
            .withTintColor(TrinapAsset.black.color, renderingMode: .alwaysOriginal)
        
        appearance.configureWithTransparentBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
    }
}

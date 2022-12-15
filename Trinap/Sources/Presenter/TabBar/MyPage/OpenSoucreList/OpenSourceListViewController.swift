//
//  OpenSourceListViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class OpenSourceListViewController: BaseViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, OpenSourceInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, OpenSourceInfo>
    
    enum Section: Hashable {
        case main
    }
    
    // MARK: - UI
    private lazy var navigationBarView = TrinapNavigationBarView().than {
        $0.setTitleText("오픈소스 라이선스")
    }
    
    private lazy var openSourceListTableView = UITableView().than {
        $0.rowHeight = 72.0
        $0.register(UITableViewCell.self)
    }
    
    private lazy var placeHolderView = PlaceHolderView(text: "오픈소스 내역이 없어요.")
    
    // MARK: - Properties
    private var dataSource: DataSource?
    private let viewModel: OpenSourceListViewModel
    
    // MARK: - Initializers
    init(viewModel: OpenSourceListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubviews([
            navigationBarView,
            openSourceListTableView
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        openSourceListTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        self.configureDataSource()
    }
    
    override func bind() {
        let input = OpenSourceListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            backButtonTap: self.navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.openSourceInfo
            .withUnretained(self)
            .map { owner, info in
                owner.configurePlaceHolderView(with: info)
                
                return owner.generateSnapshot(info)
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, snapshot in
                owner.dataSource?.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        openSourceListTableView.rx.itemSelected
            .compactMap { [weak self] indexPath -> OpenSourceInfo? in
                self?.openSourceListTableView.deselectRow(at: indexPath, animated: false)
                
                return self?.dataSource?.itemIdentifier(for: indexPath)
            }
            .map(\.url)
            .bind(onNext: { [weak self] url in
                self?.openURL(url)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Privates
private extension OpenSourceListViewController {
    func configureDataSource() {
        self.dataSource = DataSource(
            tableView: openSourceListTableView,
            cellProvider: { tableView, indexPath, openSourceInfo in
                guard let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                
                var configuration = cell.defaultContentConfiguration()
                
                configuration.text = openSourceInfo.name
                configuration.secondaryText = openSourceInfo.version
                cell.contentConfiguration = configuration
                cell.accessoryType = .disclosureIndicator
                
                return cell
            })
    }
    
    func generateSnapshot(_ info: [OpenSourceInfo]) -> Snapshot {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(info)
        return snapshot
    }
    
    func configurePlaceHolderView(with info: [OpenSourceInfo]) {
        if info.isEmpty {
            self.view.addSubview(self.placeHolderView)
            
            self.placeHolderView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBarView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        } else {
            self.placeHolderView.removeFromSuperview()
        }
    }
    
    func openURL(_ url: URL?) {
        guard let url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

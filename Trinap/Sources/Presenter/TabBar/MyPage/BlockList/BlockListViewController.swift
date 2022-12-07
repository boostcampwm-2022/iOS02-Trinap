//
//  BlockListViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BlockListViewController: BaseViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Block.BlockedUser>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Block.BlockedUser>
    
    enum Section: Hashable {
        case main
    }
    
    // MARK: - UI
    private lazy var navigationBarView = TrinapNavigationBarView().than {
        $0.setTitleText("차단목록")
    }
    
    private lazy var blockListTableView = UITableView().than {
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.rowHeight = 72.0
        $0.register(BlockListCell.self)
    }
    
    // MARK: - Properties
    private var dataSource: DataSource?
    private let viewModel: BlockListViewModel
    private let blockCancel = PublishRelay<(Bool, Block.BlockedUser)>()
    
    // MARK: - Initializers
    init(viewModel: BlockListViewModel) {
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
            blockListTableView
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        blockListTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureDataSource()
    }
    
    override func bind() {
        super.bind()
        
        let input = BlockListViewModel.Input(
            viewWillappear: self.rx.viewWillAppear.map { _ in },
            updateBlockStatus: self.blockCancel.asObservable().share(),
            backButtonTap: self.navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.blockUsers
            .compactMap { [weak self] users in
                Logger.printArray(users)
                return self?.generateSnapshot(users)
            }
            .drive(onNext: { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Privates
private extension BlockListViewController {
    func configureDataSource() {
        self.dataSource = DataSource(tableView: blockListTableView, cellProvider: { [weak self] tableView, indexPath, user in
            guard let self,
                  let cell = tableView.dequeueCell(BlockListCell.self, for: indexPath)
            else {
                return UITableViewCell()
            }
            cell.configureCell(blockedUser: user)
            
            cell.blockStatusButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .map { _ in
                    cell.isBlockStatusButtonSelected.toggle()
                    
                    return (cell.isBlockStatusButtonSelected, user)
                }
                .bind(to: self.blockCancel)
                .disposed(by: self.disposeBag)
            
            return cell
        })
    }
    
    func generateSnapshot(_ users: [Block.BlockedUser]) -> Snapshot {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        return snapshot
    }
}

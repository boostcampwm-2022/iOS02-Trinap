//
//  ChatPreviewsViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ChatPreviewsViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var chatPreviewsTableView: UITableView = {
        let tableView = UITableView()
        let rowHeight = 80.0
        
        tableView.register(ChatPreviewCell.self)
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.rowHeight = rowHeight
        tableView.allowsSelection = false
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, ChatPreview>?
    
    // MARK: - Properties
    private let viewModel: ChatPreviewsViewModel

    // MARK: - Initializers
    init(viewModel: ChatPreviewsViewModel) {
        self.viewModel = viewModel

        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(chatPreviewsTableView)
    }
    
    override func configureConstraints() {
        chatPreviewsTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.dataSource = self.configureDataSource()
    }
    
    override func bind() {
        let output = viewModel.transform(input: ChatPreviewsViewModel.Input())
        
        output.chatPreviews
            .compactMap { [weak self] chatPreviews in
                return self?.generateSnapshot(chatPreviews)
            }
            .drive { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView DiffableDataSource
private extension ChatPreviewsViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    func generateSnapshot(_ sources: [ChatPreview]) -> NSDiffableDataSourceSnapshot<Section, ChatPreview> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatPreview>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(sources)
        return snapshot
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, ChatPreview> {
        return UITableViewDiffableDataSource(
            tableView: self.chatPreviewsTableView
        ) { [weak self] tableView, indexPath, item in
            guard
                let self = self,
                let cell = tableView.dequeueCell(ChatPreviewCell.self, for: indexPath)
            else {
                return UITableViewCell()
            }
            
            let lastChatPreview = self.viewModel.lastChatPreviewObserver(of: item)
            cell.bind(lastChatPreview: lastChatPreview)
            
            return cell
        }
    }
}

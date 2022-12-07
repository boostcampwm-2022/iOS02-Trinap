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
        tableView.separatorStyle = .none
        tableView.rowHeight = rowHeight
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
    override func configureHierarchy() {
        self.view.addSubview(chatPreviewsTableView)
    }
    
    override func configureConstraints() {
        chatPreviewsTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureAttributes() {
        self.dataSource = self.configureDataSource()
        
        self.dataSource?.defaultRowAnimation = .fade
        
        self.navigationController?.navigationBar.setBackgroundImage(
            UIImage().withTintColor(TrinapAsset.white.color),
            for: .default
        )
        self.navigationItem.titleView = LargeNavigationTitleView(title: "채팅")
    }
    
    override func bind() {
        let output = viewModel.transform(input: ChatPreviewsViewModel.Input())
        
        output.chatPreviews
            .compactMap { [weak self] chatPreviews in
                return self?.generateSnapshot(chatPreviews)
            }
            .drive { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
        
        chatPreviewsTableView.rx
            .itemSelected
            .bind(onNext: { [weak self] indexPath in self?.showChatDetailViewController(at: indexPath) })
            .disposed(by: disposeBag)
    }
    
    private func showChatDetailViewController(at indexPath: IndexPath) {
        guard let chatPreview = self.dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        self.viewModel.showChatDetail(of: chatPreview)
    }
}

// MARK: - UITableView DiffableDataSource
private extension ChatPreviewsViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    func generateSnapshot(_ after: [ChatPreview]) -> NSDiffableDataSourceSnapshot<Section, ChatPreview> {
        guard
            let dataSource,
            let target = after.first,
            let before = dataSource.snapshot().itemIdentifiers.first(where: { $0.chatroomId == target.chatroomId })
        else {
            return defaultSnapshot(after)
        }
        
        var snapshot = dataSource.snapshot()
        
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        
        snapshot.deleteItems([before])
        
        guard let firstItem = snapshot.itemIdentifiers.first else { return defaultSnapshot(after) }
        
        snapshot.insertItems([target], beforeItem: firstItem)
        return snapshot
    }
    
    func defaultSnapshot(_ after: [ChatPreview]) -> NSDiffableDataSourceSnapshot<Section, ChatPreview> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatPreview>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(after)
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
    
    func chatroomIds(of chatPreviews: [ChatPreview]) -> [String] {
        return chatPreviews.map { $0.chatroomId }
    }
}

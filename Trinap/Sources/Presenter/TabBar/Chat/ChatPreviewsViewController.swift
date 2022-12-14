//
//  ChatPreviewsViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxGesture
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
    
    private lazy var placeHolderView = PlaceHolderView(text: "아직 채팅 내역이 없어요.")
    
    private var dataSource: UITableViewDiffableDataSource<Section, ChatPreview>?
    
    // MARK: - Properties
    private let viewModel: ChatPreviewsViewModel
    private let leaveTrigger = PublishRelay<Int>()

    // MARK: - Initializers
    init(viewModel: ChatPreviewsViewModel) {
        self.viewModel = viewModel

        super.init()
    }
    
    // MARK: - Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureNavigationController()
    }
    
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
        
        configureNavigationController()
    }
    
    override func bind() {
        let input = ChatPreviewsViewModel.Input(
            leaveTrigger: leaveTrigger
        )
        
        let output = viewModel.transform(input: input)
        
        output.chatPreviews
            .compactMap { [weak self] chatPreviews in
                self?.configurePlaceHolderView(with: chatPreviews)
                
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
        
        chatPreviewsTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func showChatDetailViewController(at indexPath: IndexPath) {
        guard let chatPreview = self.dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        self.viewModel.showChatDetail(of: chatPreview)
    }
}

// MARK: - Privates
private extension ChatPreviewsViewController {
    
    func configureNavigationController() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = TrinapAsset.white.color
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.scrollEdgeAppearance?.shadowColor = .clear
        
        self.navigationController?.navigationBar.topItem?.titleView = LargeNavigationTitleView(title: "채팅")
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func configurePlaceHolderView(with chatPreviews: [ChatPreview]) {
        if chatPreviews.isEmpty {
            self.view.addSubview(self.placeHolderView)
            
            self.placeHolderView.snp.makeConstraints { make in
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            }
        } else {
            self.placeHolderView.removeFromSuperview()
        }
    }
}

// MARK: - UITableView DiffableDataSource
private extension ChatPreviewsViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    func generateSnapshot(_ after: [ChatPreview]) -> NSDiffableDataSourceSnapshot<Section, ChatPreview> {
        return defaultSnapshot(after)
//        guard
//            let dataSource,
//            let target = after.first,
//            let before = dataSource.snapshot().itemIdentifiers.first(where: { $0.chatroomId == target.chatroomId })
//        else {
//            return defaultSnapshot(after)
//        }
//
//        var snapshot = dataSource.snapshot()
//
//        if snapshot.sectionIdentifiers.isEmpty {
//            snapshot.appendSections([.main])
//        }
//
//        snapshot.deleteItems([before])
//
//        guard let firstItem = snapshot.itemIdentifiers.first else { return defaultSnapshot(after) }
//
//        snapshot.insertItems([target], beforeItem: firstItem)
//        return snapshot
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

// MARK: UITableView Delegate
extension ChatPreviewsViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "나가기") { [weak self] _, _, completion in
            self?.presentLeaveAlert(at: indexPath, completion: completion)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    private func presentLeaveAlert(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let leaveMessage = "채팅방을 나가시겠습니까? 나간 채팅방의 대화 내역은 모두 사라지며, 복구할 수 없습니다."
        let alert = UIAlertController(title: nil, message: leaveMessage, preferredStyle: .alert)
            .appendingAction(title: "취소", style: .cancel)
            .appendingAction(title: "나가기", style: .destructive) { [weak self] in
                self?.leaveTrigger.accept(indexPath.row)
                completion(true)
            }
        
        self.present(alert, animated: true)
    }
}

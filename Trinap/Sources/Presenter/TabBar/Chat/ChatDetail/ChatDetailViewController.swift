//
//  ChatDetailViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ChatDetailViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var chatInputView: ChatInputView = {
        let inputView = ChatInputView()
        
        return inputView
    }()
    
    private lazy var chatTableView: ChatTableView = {
        let chatTableView = ChatTableView()
        
        chatTableView.keyboardDismissMode = .onDrag
        return chatTableView
    }()
    
    // MARK: - Properties
    private let viewModel: ChatDetailViewModel
    private var dataSource: UITableViewDiffableDataSource<Section, Chat>?
    private var imagePicker = ImagePickerController()
    
    // MARK: - Initializers
    init(viewModel: ChatDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        self.imagePicker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TrinapAsset.white.color
    }
    
    override func configureHierarchy() {
        self.view.addSubview(chatInputView)
        self.view.addSubview(chatTableView)
    }
    
    override func configureConstraints() {
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.chatInputView.snp.top)
        }
    }
    
    override func configureAttributes() {
        chatInputView.followKeyboardObserver()
            .disposed(by: disposeBag)
        
        chatTableView.followKeyboardObserver()
            .disposed(by: disposeBag)
        
        self.dataSource = self.configureDataSource()
        
        bindChatInputAction()
    }
    
    override func bind() {
        let input = ChatDetailViewModel.Input(
            didSendWithContent: chatInputView.didTapSendWithText
        )
        
        let output = viewModel.transform(input: input)
        
        output.chats
            .compactMap { [weak self] chats in self?.generateSnapshot(chats) }
            .subscribe { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: false) {
                    self?.scrollToBottom()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func scrollToBottom() {
        let lastChatIndex = viewModel.chats.value.count - 1
        let lastIndexPath = IndexPath(item: lastChatIndex, section: 0)
        
        self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
}

// MARK: - Privates
extension ChatDetailViewController {
    
    private func bindChatInputAction() {
        chatInputView.didTapAction
            .emit(onNext: { [weak self] _ in self?.presentActionAlert() })
            .disposed(by: disposeBag)
    }
    
    private func presentActionAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            .appendingAction(title: "포토 라이브러리") { [weak self] in self?.presentPhotoLibrary() }
            .appendingAction(title: "사진 촬영")
            .appendingCancel()
        
        self.present(alert, animated: true)
    }
    
    private func presentPhotoLibrary() {
        self.imagePicker
            .pickImage()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in self?.requestUploadImage(image) })
            .disposed(by: disposeBag)
    }
    
    private func presentUploadImageAlert(_ image: UIImage) {
        let alert = UIAlertController(title: nil, message: "선택한 사진을 전송합니다.", preferredStyle: .alert)
            .appendingAction(title: "전송") { [weak self] in self?.requestUploadImage(image) }
            .appendingCancel()
        
        self.present(alert, animated: true)
    }
    
    private func requestUploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        self.viewModel.uploadImageAndSendChat(imageData)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: - Diffable DataSource
extension ChatDetailViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    func generateSnapshot(_ sources: [Chat]) -> NSDiffableDataSourceSnapshot<Section, Chat> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Chat>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(sources)
        return snapshot
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Chat> {
        return UITableViewDiffableDataSource(
            tableView: self.chatTableView
        ) { [weak self] tableView, indexPath, item in
            guard
                let self = self,
                let cell = tableView.dequeueCell(item.chatType.cellClass, for: indexPath)
            else {
                return UITableViewCell()
            }
            
            let hasMyChatBefore = self.viewModel.hasMyChat(before: indexPath.row)
            cell.configureCell(by: item, hasMyChatBefore: hasMyChatBefore)
            
            return cell
        }
    }
}

private extension Chat.ChatType {
    
    var cellClass: ChatCell.Type {
        switch self {
        case .text:
            return TextChatCell.self
        case .image:
            return ImageChatCell.self
        default:
            return TextChatCell.self
//        case .reservation:
//            <#code#>
//        case .location:
//            <#code#>
        }
    }
}

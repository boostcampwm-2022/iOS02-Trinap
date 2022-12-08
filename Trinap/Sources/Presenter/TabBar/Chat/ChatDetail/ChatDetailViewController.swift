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
import Queenfisher

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
    
    private var isAlreadyFetched = false
    
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureNavigationController()
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
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.chatInputView.snp.top)
        }
    }
    
    override func configureAttributes() {
        self.view.backgroundColor = TrinapAsset.white.color
        self.title = viewModel.nickname
        
        self.dataSource = self.configureDataSource()
        
        configureNavigationController()
        
        bindChatInputAction()
    }
    
    override func bind() {
        chatInputView.followKeyboardObserver()
            .disposed(by: disposeBag)
        
        chatTableView.followKeyboardObserver()
            .disposed(by: disposeBag)
        
        let input = ChatDetailViewModel.Input(
            didSendWithContent: chatInputView.didTapSendWithText
        )
        
        let output = viewModel.transform(input: input)
        
        output.chats
            .filter { !$0.isEmpty }
            .compactMap { [weak self] chats in self?.generateSnapshot(chats) }
            .subscribe { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: false) {
                    self?.scrollToBottom()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func scrollToBottom() {
        let lastChatIndex = viewModel.lastChatIndex()
        let lastIndexPath = IndexPath(row: lastChatIndex, section: 0)
        
        self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: isAlreadyFetched)
        isAlreadyFetched = true
    }
}

// MARK: - Privates
private extension ChatDetailViewController {
    
    func configureNavigationController() {
        let appearance = UINavigationBarAppearance()
        let backButtonImage = UIImage(systemName: "arrow.left")?
            .withTintColor(TrinapAsset.black.color, renderingMode: .alwaysOriginal)
        
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = TrinapAsset.white.color
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func bindChatInputAction() {
        chatInputView.didTapAction
            .emit(onNext: { [weak self] _ in self?.presentActionAlert() })
            .disposed(by: disposeBag)
    }
    
    func presentActionAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            .appendingAction(title: "포토 라이브러리") { [weak self] in self?.presentPhotoLibrary() }
            .appendingAction(title: "위치 공유") { [weak self] in self?.sendLocationShareChat() }
            .appendingCancel()
        
        self.present(alert, animated: true)
    }
    
    func presentPhotoLibrary() {
        self.imagePicker
            .pickImage()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in self?.requestUploadImage(image) })
            .disposed(by: disposeBag)
    }
    
    func presentUploadImageAlert(_ image: UIImage) {
        let alert = UIAlertController(title: nil, message: "선택한 사진을 전송합니다.", preferredStyle: .alert)
            .appendingAction(title: "전송") { [weak self] in self?.requestUploadImage(image) }
            .appendingCancel()
        
        self.present(alert, animated: true)
    }
    
    func requestUploadImage(_ image: UIImage) {
        let downsampledImage = downsamplingImageWithSize(image)
        
        guard let imageData = downsampledImage.image.jpegData(compressionQuality: 1) else { return }
        
        self.viewModel.uploadImageAndSendChat(
            imageData,
            width: downsampledImage.size.width,
            height: downsampledImage.size.height
        )
        .subscribe()
        .disposed(by: disposeBag)
    }
    
    func downsamplingImageWithSize(_ image: UIImage) -> (image: UIImage, size: CGSize) {
        let widthLimit = 200.0
        var width = image.size.width
        var height = image.size.height
        
        if width > widthLimit {
            let ratio = widthLimit / width
            width *= ratio
            height *= ratio
        }
        
        return (
            image.downsampling(to: CGSize(width: width, height: height), scale: 2),
            CGSize(width: width, height: height)
        )
    }
    
    func sendLocationShareChat() {
        self.viewModel.sendLocationShareChatAndPresent()
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
            cell.configureCell(by: item, hasMyChatBefore: hasMyChatBefore) {
                guard var snapshot = self.dataSource?.snapshot() else { return }
                snapshot.reloadItems([item])
            }
            
            self.observeTapActionIfPossible(cell, disposedBy: item.chatId)
            
            return cell
        }
    }
    
    private func observeTapActionIfPossible(_ cell: ChatCell, disposedBy id: String) {
        guard let actionCell = cell as? ActionChatCell else { return }
        
        actionCell.didTapAction
            .subscribe(onNext: { [weak self] _ in
                self?.handleChatActionButtonTapped(actionCell)
            })
            .disposed(by: actionCell.actionDisposeBag)
    }
    
    private func handleChatActionButtonTapped(_ cell: ActionChatCell) {
        switch cell {
        case is LocationShareChatCell:
            viewModel.presentLocationShare()
        case is ReservationChatCell:
            Logger.print("Reservation")
        default:
            break
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
        case .reservation:
            return ReservationChatCell.self
        case .location:
            return LocationShareChatCell.self
        }
    }
}

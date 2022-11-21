//
//  ChatDetailViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import MessageKit
import RxCocoa
import RxSwift
import SnapKit

final class ChatDetailViewController: BaseViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - UI
    private lazy var chatInputView: ChatInputView = {
        let inputView = ChatInputView()
        
        return inputView
    }()
    
    private lazy var chatTableView: ChatTableView = {
        let chatTableView = ChatTableView()
        
        chatTableView.dataSource = self
        chatTableView.keyboardDismissMode = .onDrag
        chatTableView.register(ChatCell.self)
        chatTableView.register(TextChatCell.self)
        return chatTableView
    }()
    
    // MARK: - Properties
    private let viewModel: ChatDetailViewModel
    
    // MARK: - Initializers
    init(viewModel: ChatDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
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
    }
    
    override func bind() {
        let input = ChatDetailViewModel.Input(
            didSendWithContent: chatInputView.didTapSendWithText
        )
        
        let output = viewModel.transform(input: input)
        
        output.chats
            .subscribe { [weak self] chats in
                Logger.printArray(chats)
                self?.chatTableView.reloadData()
                self?.scrollToBottom()
            }
            .disposed(by: disposeBag)
    }
    
    private func scrollToBottom() {
        let lastChatIndex = viewModel.chats.value.count - 1
        let lastIndexPath = IndexPath(item: lastChatIndex, section: 0)
        
        self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
}

extension ChatDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chats.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = viewModel.chats.value[indexPath.item]
        guard let cell = tableView.dequeueCell(chat.chatType.cellClass, for: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configureCell(by: chat)
        
        return cell
    }
}

private extension Chat.ChatType {
    
    var cellClass: ChatCell.Type {
        return TextChatCell.self
// TODO: - Cell 만들면 채울 것
//        switch self {
//        case .text:
//            return TextChatCell.self
//        case .image:
//            <#code#>
//        case .reservation:
//            <#code#>
//        case .location:
//            <#code#>
//        }
    }
}

extension String {
    
    func width(by font: UIFont) -> CGFloat {
        var textWidth: CGFloat = 0
        for element in self {
            let characterString = String(element)
            let letterSize = characterString.size(withAttributes: [.font: font])
            textWidth += letterSize.width
        }
        return textWidth + 1
    }
}

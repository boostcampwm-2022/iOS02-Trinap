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
    
    // MARK: - UI
    private lazy var chatInputView: ChatInputView = {
        let inputView = ChatInputView()
        
        return inputView
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
    }
    
    override func configureHierarchy() {
        self.view.addSubview(chatInputView)
    }
    
    override func configureConstraints() {
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
    }
    
    override func configureAttributes() {
        
    }
    
    override func bind() {
        let input = ChatDetailViewModel.Input(
            didSendWithContent: chatInputView.didTapSendWithText
        )
        
        let output = viewModel.transform(input: input)
        
        output.chats
            .subscribe { chats in
                Logger.printArray(chats)
            }
            .disposed(by: disposeBag)
    }
}

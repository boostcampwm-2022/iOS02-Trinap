//
//  CreateUserViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

final class CreateUserViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var navigationBarView = TrinapNavigationBarView()
    
    private lazy var titleLabel = UILabel().than {
        $0.text = "만나서 반가워요!\n트리냅과 추억을 만들어 보세요"
        $0.numberOfLines = 0
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 24)
    }
    
    private lazy var subTitleLabel = UILabel().than {
        $0.text = "트리냅 이용을 위해 닉네임을 설정해 주세요."
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    private lazy var nicknameTextFieldView = NicknameTextFieldView()
    
    private lazy var signUpButton = TrinapButton(
        style: .primary
    ).than {
        $0.setTitle("가입 완료", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }

    // MARK: - Properties
    private let viewModel: CreateUserViewModel

    // MARK: - Initializers
    init(viewModel: CreateUserViewModel) {
        self.viewModel = viewModel

        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            navigationBarView,
            titleLabel,
            subTitleLabel,
            nicknameTextFieldView,
            signUpButton
        ])
    }

    override func configureConstraints() {
        navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(trinapOffset)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(trinapOffset * 2)
        }
                
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(trinapOffset)
            make.leading.centerX.equalTo(titleLabel)
        }

        nicknameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(trinapOffset * 3)
            make.leading.centerX.equalTo(titleLabel)
            make.height.equalTo(trinapOffset * 6)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldView.snp.bottom).offset(trinapOffset * 2)
            make.leading.centerX.equalTo(titleLabel)
            make.height.equalTo(trinapOffset * 6)
        }
    }

    override func bind() {
        let input = CreateUserViewModel.Input(
            nickname: nicknameTextFieldView.textField.rx.text.orEmpty.asObservable(),
            signUpButtonTap: signUpButton.rx.tap.asObservable(),
            generateButtonTap: nicknameTextFieldView.generateButton.rx.tap.asObservable(),
            backButtonTap: self.navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.signUpButtonEnable
            .asObservable()
            .bind(to: self.signUpButton.rx.enabled)
            .disposed(by: disposeBag)
        
        output.randomNickName
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, nickname in
                owner.nicknameTextFieldView.textField.text = nickname
                owner.nicknameTextFieldView.textField.sendActions(for: .valueChanged)
            }
            .disposed(by: disposeBag)
    }
}

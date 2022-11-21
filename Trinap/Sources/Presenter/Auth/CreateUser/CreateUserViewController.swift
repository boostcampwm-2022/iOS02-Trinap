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
    private lazy var titleLabel = UILabel().than {
        $0.text = "만나서 반가워요!\nTrinap과 추억을 만들어 보세요"
        $0.numberOfLines = 0
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 24)
    }
    
    private lazy var subTitleLabel = UILabel().than {
        $0.text = "Trinap 이용을 위해 닉네임을 설정해 주세요."
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    private lazy var nicknameTextFieldView = NicknameTextFieldView()
    
    private lazy var signUpButton = TrinapButton(
        style: .primary
    ).than {
        $0.setTitle("가입 완료", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.isEnabled = false
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
        [
            titleLabel,
            subTitleLabel,
            nicknameTextFieldView,
            signUpButton
        ].forEach { self.view.addSubview($0) }
    }

    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
                
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.centerX.equalTo(titleLabel)
        }

        nicknameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.leading.centerX.equalTo(titleLabel)
            make.height.equalTo(48)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldView.snp.bottom).offset(16)
            make.leading.centerX.equalTo(titleLabel)
            make.height.equalTo(48)
        }
    }
    
    override func configureAttributes() {
        configureNavigationBar()
    }

    override func bind() {
        let input = CreateUserViewModel.Input(
            nickname: nicknameTextFieldView.textField.rx.text.orEmpty.asObservable(),
            signUpButtonTap: signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.signUpButtonEnable
            .drive { [weak self] result in
                self?.signUpButton.isEnabled = result
            }
            .disposed(by: disposeBag)
        
        output.signUpFailure
            .asObservable()
            .subscribe {
                Logger.print("회원가입 실패")
            }
            .disposed(by: disposeBag)
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = TrinapAsset.white.color
        self.navigationController?.navigationBar.barTintColor = TrinapAsset.white.color
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

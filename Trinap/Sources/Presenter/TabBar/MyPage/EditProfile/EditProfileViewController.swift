//
//  EditProfileViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxGesture

final class EditProfileViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var doneButton = UIButton().than {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(TrinapAsset.primary.color, for: .normal)
    }
    
    private lazy var navigationBarView = TrinapNavigationBarView().than {
        $0.setTitleText("정보 수정")
        $0.addRightButton(doneButton)
    }
    
    private lazy var profileImageView = ProfileImageView()
    
    private var editIconView = UIImageView().than {
        $0.image = UIImage(systemName: "camera.fill")
        $0.backgroundColor = TrinapAsset.white.color
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var nickNameLabel = UILabel().than {
        $0.text = "닉네임"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var nickNameInputView = NicknameTextFieldView()
    
    // MARK: - Properties
    private let imagePicker = ImagePickerController()
    private let viewModel: EditProfileViewModel
    
    // MARK: - Initialize
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Configure
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubviews([
            navigationBarView,
            profileImageView,
            editIconView,
            nickNameLabel,
            nickNameInputView
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationBarView.snp.bottom).offset(trinapOffset * 3)
            make.width.height.equalTo(trinapOffset * 8)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(trinapOffset * 2)
            make.top.equalTo(profileImageView.snp.bottom).offset(trinapOffset * 3)
        }
        
        nickNameInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(trinapOffset)
            make.height.equalTo(trinapOffset * 5)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        self.hideKeyboardWhenTapped()
        imagePicker.delegate = self
    }
    
    override func bind() {
        super.bind()
        
        let imageData = self.profileImageView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.imagePicker.pickImage()
            }
            .share()

        imageData.bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        let input = EditProfileViewModel.Input(
            nickname: nickNameInputView.textField.rx.text.orEmpty.asObservable(),
            nicknameTrigger: nickNameInputView.generateButton.rx.tap.asObservable(),
            profileImage: imageData.map { $0.jpegData(compressionQuality: 1.0) },
            buttonTrigger: doneButton.rx.tap.asObservable(),
            backButtonTap: navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.nickName
            .bind(to: nickNameInputView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.result.subscribe(onNext: {
            self.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)
        
        output.defaultImage
            .bind(to: profileImageView.rx.setImage)
            .disposed(by: disposeBag)
    }
}

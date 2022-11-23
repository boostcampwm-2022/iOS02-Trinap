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
    
    // MARK: - Properties
    private let imagePicker = ImagePickerController()
    private let viewModel: EditProfileViewModel
    
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
    
    private lazy var doneButton = UIButton().than {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Initialize
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Configure
    override func configureHierarchy() {
        self.view.addSubviews([profileImageView, editIconView, nickNameLabel, nickNameInputView])
    }
    
    override func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(trinapOffset * 3)
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
        imagePicker.delegate = self
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    override func bind() {
        
        let textField = self.nickNameInputView.textField.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .withLatestFrom(
                nickNameInputView.textField.rx.text
                    .orEmpty
                    .asObservable()
                    .distinctUntilChanged()
            )
        
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
            nickname: textField,
            nicknameTrigger: nickNameInputView.generateButton.rx.tap.asObservable(),
            profileImage: imageData.map { $0.jpegData(compressionQuality: 1.0) },
            buttonTrigger: doneButton.rx.tap.asObservable())
        
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

//
//  AddContactViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class CreateContactViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: CreateContactViewModel
    
    private lazy var titleTextField = UITextField().than {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = TrinapAsset.subtext2.color.cgColor
        $0.layer.borderWidth = 1
        
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: trinapOffset * 1.5, height: trinapOffset * 5))
        $0.leftViewMode = .always
        
        $0.font = TrinapFontFamily.Pretendard.semiBold.font(size: 16)
        $0.textColor = TrinapAsset.black.color
        $0.placeholder = "제목을 입력해주세요"
    }
    
    private lazy var contentsTextView = UITextView().than {
        
        let offset = trinapOffset * 1.5
        $0.textContainerInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = TrinapAsset.subtext2.color.cgColor
        $0.layer.borderWidth = 1
        
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.text = viewModel.placeholder
        $0.textColor = TrinapAsset.subtext2.color
    }
    
    private lazy var submitButton = TrinapButton(style: .primary).than {
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 18)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("등록하기", for: .normal)
        $0.style = .disabled
        $0.isEnabled = false
    }
    
    // MARK: - Initializers
    init(viewModel: CreateContactViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([titleTextField, contentsTextView, submitButton])
    }
    
    override func configureConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(trinapOffset * 3)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(trinapOffset * 2)
            make.height.equalTo(trinapOffset * 6)
        }
        
        submitButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(trinapOffset * 3)
            make.bottom.equalToSuperview().inset(trinapOffset * 3)
            make.height.equalTo(trinapOffset * 7)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(trinapOffset * 3)
            make.top.equalTo(titleTextField.snp.bottom).offset(trinapOffset * 2)
            make.bottom.equalTo(submitButton.snp.top).offset(-trinapOffset * 2)
        }
    }
    
    override func configureAttributes() {
        
    }
    
    override func bind() {
        let input = CreateContactViewModel.Input(
            title: titleTextField.rx.text.orEmpty.asObservable(),
            contents: contentsTextView.rx.text.orEmpty.asObservable(),
            buttonTrigger: submitButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.isValid
            .bind(to: submitButton.rx.enabled)
            .disposed(by: disposeBag)
        
        contentsTextView.rx.didBeginEditing
            .bind { [weak self] _ in
                guard let self else { return }
                
                if self.contentsTextView.text == self.viewModel.placeholder {
                    self.contentsTextView.text = nil
                    self.contentsTextView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        contentsTextView.rx.didEndEditing
            .bind { [weak self] _ in
                guard let self else { return }
                if self.contentsTextView.text == nil || self.contentsTextView.text.isEmpty {
                    self.contentsTextView.text = self.viewModel.placeholder
                    self.contentsTextView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
    }
}

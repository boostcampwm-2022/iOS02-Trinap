//
//  SueViewController.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

final class SueViewController: BaseViewController {

    // MARK: - UI
    private lazy var titleLabel = UILabel().than {
        $0.textAlignment = .left
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var subtitleLabel = UILabel().than {
        $0.textAlignment = .left
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.text = "더 나은 트리냅 이용을 위해 신고 사유를 선택해주세요."
    }
    
    private lazy var textView = UITextView().than {
        $0.text = self.viewModel.placeholder
        
        let offset = trinapOffset * 1.5
        
        $0.textContainerInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = TrinapAsset.subtext2.color.cgColor
        $0.layer.borderWidth = 1
        
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = TrinapAsset.subtext2.color
    }
    
    private lazy var confirmButton = TrinapButton(style: .primary, fillType: .fill).than {
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 18)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("신고하기", for: .normal)
        $0.style = .disabled
        $0.isEnabled = false
    }
    
    // MARK: - Properties
    private let viewModel: SueViewModel

    // MARK: - Initializers
    init(viewModel: SueViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureHierarchy() {
        self.view.addSubviews([
            titleLabel,
            subtitleLabel,
            textView,
            confirmButton
        ])
    }

    override func configureConstraints() {
        let offset = 12
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().offset(offset)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(offset)
            make.height.equalTo(120)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(offset)
            make.height.equalTo(48)
        }
    }

    override func bind() {
        let contents = textView.rx.text.orEmpty.asObservable().map {
            return Sue.SueContents.etc($0)
        }
        
        let input = SueViewModel.Input(
            sueContents: contents,
            confirmTrigger: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        textView.rx.didBeginEditing
            .bind { [weak self] _ in
                guard let self else { return }
                
                if self.textView.text == self.viewModel.placeholder {
                    self.textView.text = nil
                    self.textView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .bind { [weak self] _ in
                guard let self else { return }
                if self.textView.text == nil || self.textView.text.isEmpty {
                    self.textView.text = self.viewModel.placeholder
                    self.textView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
        
        output.userName
            .asObservable()
            .map { "'\($0)' 님을 신고하고 싶어요" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .drive(confirmButton.rx.enabled)
            .disposed(by: disposeBag)
    }
}

//
//  CreateReviewViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

final class CreateReviewViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: CreateReviewViewModel
    
    private lazy var titleLabel = UILabel().than {
        $0.text = "좋은 추억을 남기셨나요?\n작가님을 위해 리뷰를 작성해 주세요."
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }
    
    private lazy var ratingLabel = UILabel().than {
        $0.text = "평점"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
    }
    
    private lazy var reviewLabel = UILabel().than {
        $0.text = "리뷰 작성"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
    }
    
    private lazy var ratingView = RatingView(style: .create).than {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var reviewTextView = UITextView().than {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        
        $0.text = "작가님을 위한 한마디를 남겨주세요!"
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private lazy var submitButton = TrinapButton(style: .disabled).than {
        $0.setTitle("작성 완료", for: .normal)
        $0.isEnabled = false
    }
    
    // MARK: - Initializers
    init(viewModel: CreateReviewViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        [titleLabel, ratingLabel, ratingView, reviewLabel, reviewTextView, submitButton]
            .forEach { self.view.addSubview($0) }
    }
    
    override func configureConstraints() {
        
        let offset = self.view.frame.width * 0.03 // 8
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset * 3)
            make.leading.equalToSuperview().offset(offset * 2)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(offset * 3)
        }
        
        ratingView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(offset * 2)
            make.trailing.equalToSuperview().offset(-(offset * 2))
            make.top.equalTo(ratingLabel.snp.bottom).offset(offset)
            make.height.equalTo(90)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(ratingView.snp.bottom).offset(offset * 2)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(ratingView)
            make.top.equalTo(reviewLabel.snp.bottom).offset(offset)
            make.height.equalTo(300)
        }
        
        submitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(offset * 2)
            make.trailing.equalToSuperview().offset(-(offset * 2))
            make.bottom.equalToSuperview().offset(-(offset * 4))
            make.height.equalTo(50)
        }
    }
    
    override func configureAttributes() {
        self.hideKeyboardWhenTapped()
    }
    
    override func bind() {
        
        reviewTextView.rx.didBeginEditing
            .bind { [weak self] _ in
                if self?.reviewTextView.text == "작가님을 위한 한마디를 남겨주세요!"{
                    self?.reviewTextView.text = nil
                    self?.reviewTextView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        reviewTextView.rx.didEndEditing
            .bind { [weak self] _ in
                guard let self else { return }
                if self.reviewTextView.text == nil || self.reviewTextView.text.isEmpty {
                    self.reviewTextView.text = "작가님을 위한 한마디를 남겨주세요!"
                    self.reviewTextView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
        
        let text = reviewTextView.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
        
        let buttonTrigger = submitButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .asObservable()
        
        let input = CreateReviewViewModel.Input(
            rating: ratingView.currentRate,
            contents: text,
            textViewEndEditing: reviewTextView.rx.didEndEditing.asObservable(),
            trigger: buttonTrigger
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonEnabled
            .bind(to: self.submitButton.rx.enabled)
            .disposed(by: disposeBag)
        
        output.result
            .subscribe(onNext: { flag in
                print(flag)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

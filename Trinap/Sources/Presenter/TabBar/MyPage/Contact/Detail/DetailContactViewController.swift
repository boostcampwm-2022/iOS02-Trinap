//
//  DetailContactViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DetailContactViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var navigationBarView = TrinapNavigationBarView().than {
        $0.setTitleText("문의 상세내역")
    }
    
    private lazy var titleLabel = UILabel().than {
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 24)
        $0.sizeToFit()
    }
    
    private lazy var contentsLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.black.color
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    // MARK: - Properties
    private let viewModel: DetailContactViewModel
    
    // MARK: - Initializers
    init(viewModel: DetailContactViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            navigationBarView,
            titleLabel,
            contentsLabel
        ])
    }
    
    override func configureConstraints() {
        navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(navigationBarView.snp.bottom).offset(trinapOffset * 3)
            make.height.equalTo(trinapOffset * 4)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(titleLabel.snp.bottom).offset(trinapOffset * 2)
        }
    }
    
    override func configureAttributes() {
        self.navigationController?.navigationBar.tintColor = TrinapAsset.black.color
    }
    
    override func bind() {
        let input = DetailContactViewModel.Input(
            backButtonTap: self.navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.contents
            .bind(to: contentsLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

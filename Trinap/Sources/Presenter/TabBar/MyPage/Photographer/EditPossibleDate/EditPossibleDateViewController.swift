//
//  EditPossibleDateViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class EditPossibleDateViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var titleLabel = UILabel().than {
        $0.text = "촬영이 가능하신\n날짜를 선택해 주세요"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
        $0.numberOfLines = 0
    }
    
    private lazy var editDoneButton = UIButton().than {
        $0.setTitleColor(TrinapAsset.primary.color, for: .normal)
        $0.setTitleColor(TrinapAsset.disabled.color, for: .disabled)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.semiBold.font(size: 16)
    }
    
    private lazy var navigationBarView = TrinapNavigationBarView().than {
        $0.setTitleText("작가 영업일 설정")
        $0.addRightButton(self.editDoneButton)
    }
    
    private lazy var trinapCalenderView = TrinapMultiSelectionCalendarView()
    
    // MARK: - Properties
    private let viewModel: EditPossibleDateViewModel
    
    // MARK: - Initializers
    init(viewModel: EditPossibleDateViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        configureNavigationBar()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubviews([
            navigationBarView,
            titleLabel,
            trinapCalenderView
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        self.navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(trinapOffset * 3)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(trinapOffset * 2)
        }
        
        self.trinapCalenderView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(trinapOffset * 3)
            make.leading.centerX.equalTo(titleLabel)
        }
    }

    override func bind() {
        super.bind()
        
        let input = EditPossibleDateViewModel.Input(
            calendarDateTap: self.trinapCalenderView.possibleDate.asObservable(),
            possibleDateEditDone: self.editDoneButton.rx.tap
                .asObservable()
                .withUnretained(self)
                .map { owner, _ in
                    return owner.trinapCalenderView.possibleDate.value
                },
            backButtonTap: self.navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.fetchPossibleDate
            .withUnretained(self)
            .subscribe(onNext: { owner, possibleDate in
                owner.trinapCalenderView.configurePossibleDate(possibleDate: possibleDate)
            })
            .disposed(by: disposeBag)
        
        output.editDoneButtonEnable
            .drive(onNext: { [weak self] isEnabled in
                guard let self else { return }
                self.editDoneButton.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
        
        output.editResult
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

private extension EditPossibleDateViewController {
    
    func configureNavigationBar() {
        self.navigationItem.title = "작가 영업일 설정"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.editDoneButton)
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = TrinapAsset.black.color
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

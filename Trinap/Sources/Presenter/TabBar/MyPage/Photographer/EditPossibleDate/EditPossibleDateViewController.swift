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
    
    private lazy var trinapCalenderView = TrinapMultiSelectionCalendarView()
    
    // MARK: - Properties
    private let viewModel: EditPossibleDateViewModel
    
    // MARK: - Initializers
    init(viewModel: EditPossibleDateViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        self.view.addSubviews([
            titleLabel,
            trinapCalenderView
        ])
    }
    
    override func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(trinapOffset * 3)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(trinapOffset * 2)
        }
        
        self.trinapCalenderView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(trinapOffset * 3)
            make.leading.centerX.equalTo(titleLabel)
        }
    }
    
    override func configureAttributes() {
        configureNavigationBar()
    }
    
    override func bind() {
        let input = EditPossibleDateViewModel.Input(
            calendarDateTap: self.trinapCalenderView.possibleDate.asObservable(),
            possibleDateEditDone: self.editDoneButton.rx.tap
                .asObservable()
                .withUnretained(self)
                .map { owner, _ in
                    return owner.trinapCalenderView.possibleDate.value
                }
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.fetchPossibleDate
            .withUnretained(self)
            .subscribe(onNext: { owner, possibleDate in
                owner.trinapCalenderView.configurePossibleDate(possibleDate: possibleDate)
            })
            .disposed(by: disposeBag)
        
        output.editDoneButtonEnable
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, isEnabled in
                owner.updateEditDoneButtonEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.editResult
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func updateEditDoneButtonEnabled(_ isEnabled: Bool) {
        self.editDoneButton.isEnabled = isEnabled
    }
}

private extension EditPossibleDateViewController {
    
    func configureNavigationBar() {
        self.navigationItem.title = "작가 영업일 설정"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.editDoneButton)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.backgroundColor = TrinapAsset.white.color
        self.navigationController?.navigationBar.barTintColor = TrinapAsset.white.color
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

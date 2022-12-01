//
//  DropOutViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/30.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DropOutViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var titleLabel = UILabel().than {
        $0.text = "맨도롱또똣님과\n좋은 추억을 더 남기지 못해서 아쉬워요.."
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = TrinapAsset.black.color
        $0.numberOfLines = 0
    }
    
    private lazy var subTitleLabel = UILabel().than {
        $0.text = "떠나시기 전에 안내사항을 꼭 확인해 주세요."
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = TrinapAsset.black.color
    }
    
    private lazy var warningStackView = UIStackView().than {
        let trinapDoubleOffset = trinapOffset * 2
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layer.cornerRadius = 8
        $0.layoutMargins = UIEdgeInsets(
            top: trinapDoubleOffset,
            left: trinapDoubleOffset,
            bottom: trinapDoubleOffset,
            right: trinapDoubleOffset
        )
        
        $0.backgroundColor = TrinapAsset.background.color
        $0.axis = .vertical
        $0.spacing = trinapOffset * 2
    }
    
    private lazy var agreeDropOutButton = UIButton().than {
        $0.setImage(TrinapAsset.checkBox.image, for: .normal)
        $0.setImage(TrinapAsset.checkBoxFill.image, for: .selected)
        
        $0.setTitle("안내 사항을 확인했으며, 동의할게요.", for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        $0.setTitleColor(TrinapAsset.subtext.color, for: .normal)
        $0.contentHorizontalAlignment = .leading
        $0.titleEdgeInsets.left = trinapOffset
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var warningStackView1 = WarningLabelView(
        warningText: "트리냅을 떠나시면 포트폴리오, 채팅, 리뷰, 프로필정보 등 모든 정보가 삭제되며 삭제된 정보는 더이상 복구할 수 없어요."
    )
    
    private lazy var warningStackView2 = WarningLabelView(
        warningText: "탈퇴 후 15일 동안 다시 가입할 수 없어요."
    )
    
    private lazy var buttonStackView = UIStackView().than {
        $0.axis = .horizontal
        $0.spacing = trinapOffset
        $0.distribution = .fillEqually
    }
    
    private lazy var dropOutButton = TrinapButton(style: .black, fillType: .fill, isCircle: false).than {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.isEnabled = false
        $0.style = .disabled
    }
    
    private lazy var cancelButton = TrinapButton(style: .primary, fillType: .fill, isCircle: false).than {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    // MARK: - Properties
    private let viewModel: DropOutViewModel
    
    // MARK: - Initializers
    init(viewModel: DropOutViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = DropOutViewModel.Input(
            dropOutButtonTap: self.dropOutButton.rx.tap.asObservable(),
            cancelButtonTap: self.cancelButton.rx.tap.asObservable()
        )
        
        _ = self.viewModel.transform(input: input)
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            titleLabel,
            subTitleLabel,
            warningStackView,
            agreeDropOutButton,
            buttonStackView
        ])
        
        [
            warningStackView1,
            warningStackView2
        ].forEach { self.warningStackView.addArrangedSubview($0) }
        
        [
            dropOutButton,
            cancelButton
        ].forEach { self.buttonStackView.addArrangedSubview($0) }
    }
    
    override func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(trinapOffset * 3)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(trinapOffset * 2)
        }
 
        self.subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(trinapOffset)
            make.leading.centerX.equalTo(titleLabel)
        }
        
        self.warningStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(trinapOffset * 3)
            make.leading.centerX.equalTo(titleLabel)
        }
        
        self.agreeDropOutButton.snp.makeConstraints { make in
            make.top.equalTo(warningStackView.snp.bottom).offset(trinapOffset * 3)
            make.leading.equalTo(titleLabel)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(trinapOffset)
            make.height.equalTo(48)
            make.leading.centerX.equalTo(titleLabel)
        }
    }
    
    override func configureAttributes() {
        self.configureButton()
    }
    
    private func configureButton() {
        self.agreeDropOutButton.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.agreeDropOutButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        self.agreeDropOutButton.rx.tap.asObservable()
            .withUnretained(self)
            .map { owner, _ -> Bool in
                return owner.agreeDropOutButton.isSelected
            }
            .bind(to: self.dropOutButton.rx.enabled)
            .disposed(by: disposeBag)
    }
}

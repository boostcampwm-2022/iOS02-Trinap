//
//  ProfileCell.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift

final class ProfileCell: BaseTableViewCell {
    
    var user: User? {
        didSet { configure() }
    }
    
    private lazy var profileImageView = ProfileImageView()
    
    private lazy var nickNameLabel = UILabel().than {
        $0.text = "어디로든떠나요"
        $0.textAlignment = .center
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
    
    private lazy var editButton = TrinapButton(style: .disabled, fillType: .border, isCircle: true).than {
        $0.setTitle("정보 수정", for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.regular.font(size: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func configureHierarchy() {
        self.contentView.addSubviews([profileImageView, nickNameLabel, editButton])
    }
    
    override func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(trinapOffset * 3)
            make.width.height.equalTo(trinapOffset * 8)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(trinapOffset * 2)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom).offset(trinapOffset)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
    }
    
    override func configureAttributes() {
        self.backgroundColor = TrinapAsset.background.color
    }
    
    private func configure() {
        guard let user = self.user else { return }
        profileImageView.setImage(at: user.profileImage)
        nickNameLabel.text = user.nickname
    }
    
    override func bind() {
        editButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.delegate?.didTapButton?()
            }
            .disposed(by: disposeBag)
    }
}

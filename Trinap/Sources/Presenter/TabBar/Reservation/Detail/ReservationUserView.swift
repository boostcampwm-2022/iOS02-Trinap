//
//  ReservationUserView.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class ReservationUserView: BaseView {
    
    typealias UserType = Reservation.UserType
    
    // MARK: - UI
    private lazy var userTypeLabel = UILabel().than {
        $0.text = "\(userType.rawValue) 정보"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = TrinapAsset.subtext.color
    }
    
    private lazy var profileImageView = ProfileImageView()
    
    private lazy var nicknameLabel = UILabel().than {
        $0.text = "\(userType.rawValue)"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = TrinapAsset.black.color
    }
    
    // MARK: - Properties
    private let userType: UserType
    
    // MARK: - Initializers
    init(userType: UserType) {
        self.userType = userType
        
        super.init(frame: .zero)
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubviews([
            userTypeLabel,
            profileImageView,
            nicknameLabel
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        userTypeLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(userTypeLabel.snp.bottom).offset(16)
            make.width.height.equalTo(48)
            make.leading.bottom.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
    
    func setUser(_ user: User) {
        self.profileImageView.setImage(at: user.profileImage)
        self.nicknameLabel.text = "\(user.nickname) \(userType.rawValue)"
    }
}

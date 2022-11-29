//
//  ReservationCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class ReservationCell: BaseTableViewCell {
    
    // MARK: - Properties
    private lazy var profileImageView = ProfileImageView()
    
    private lazy var nicknameLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.black.color
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private lazy var dateLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 12)
        $0.textColor = TrinapAsset.subtext2.color
    }
    
    private lazy var reservationStatusButton = TrinapButton(style: .primary)
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.contentView.addSubviews([
            profileImageView,
            nicknameLabel,
            dateLabel,
            reservationStatusButton
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        let padding = 16.0
        
        profileImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(padding)
            make.width.equalTo(self.profileImageView.snp.height)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(padding)
            make.top.equalToSuperview().offset(padding + 2)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.nicknameLabel)
            make.bottom.equalToSuperview().offset(-(padding + 2))
        }
        
        reservationStatusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-padding)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(_ item: Reservation.Preview, reservationFilter: ReservationFilter) {
        switch reservationFilter {
        case .receive:
            configureCell(item, byUser: item.customerUser)
        case .send:
            configureCell(item, byUser: item.photographerUser)
        }
    }
}

// MARK: - Privates
private extension ReservationCell {
    
    func configureCell(_ item: Reservation.Preview, byUser user: User) {
        self.profileImageView.setImage(at: user.profileImage)
        self.nicknameLabel.text = user.nickname
        self.dateLabel.text = item.reservationStartDate.toString(type: .yearAndMonth)
        self.reservationStatusButton.setTitle("예약 확인", for: .normal)
    }
}

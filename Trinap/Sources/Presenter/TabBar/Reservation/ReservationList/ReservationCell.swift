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
    
    private lazy var reservationStatusButton = TrinapButton(style: .primary).than {
        $0.setTitle("예약 완료", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
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
            make.trailing.lessThanOrEqualTo(self.reservationStatusButton.snp.leading).offset(-padding)
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
            configureCell(item, byUser: item.customerUser, nicknamePostfix: "고객님")
        case .send:
            configureCell(item, byUser: item.photographerUser, nicknamePostfix: "작가님")
        }
    }
}

// MARK: - Privates
private extension ReservationCell {
    
    func configureCell(_ item: Reservation.Preview, byUser user: User, nicknamePostfix: String) {
        let reservationStatusContent = item.status.content
        
        self.profileImageView.setImage(at: user.profileImage)
        self.nicknameLabel.text = "\(user.nickname) \(nicknamePostfix)"
        self.dateLabel.text = item.reservationStartDate.toString(type: .monthAndDate)
        self.reservationStatusButton.setTitle(reservationStatusContent.text, for: .normal)
        self.reservationStatusButton.style = reservationStatusContent.style
    }
}

// MARK: - Reservation.Status
extension Reservation.Status {
    
    var content: (text: String, style: TrinapButton.ColorType) {
        switch self {
        case .request:
            return ("예약 요청", .secondary)
        case .confirm:
            return ("예약 확정", .primary)
        case .done:
            return ("촬영 완료", .black)
        case .cancel:
            return ("예약 취소", .error)
        }
    }
}

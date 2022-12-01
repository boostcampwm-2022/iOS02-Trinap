//
//  TimeCell.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Than

final class TimeCell: BaseCollectionViewCell {
    private lazy var timeLabel = UILabel().than {
        $0.text = "00:00"
        $0.textAlignment = .center
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateSelectionAttributes(isSelected)
        }
    }
    
    
    override func configureHierarchy() {
        self.contentView.addSubview(timeLabel)
    }
    
    override func configureConstraints() {
        self.timeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.contentView.backgroundColor = TrinapAsset.background.color
        self.contentView.layer.cornerRadius = trinapOffset
    }
    
    func configureCell(with reservationDate: ReservationDate) {
        self.timeLabel.text = reservationDate.date.toString(type: .hourAndMinute)
    }
    
    private func updateSelectionAttributes(_ isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = TrinapAsset.primary.color
            self.timeLabel.textColor = TrinapAsset.white.color
            self.timeLabel.font = TrinapFontFamily.Pretendard.semiBold.font(size: 14)
        } else {
            self.contentView.backgroundColor = TrinapAsset.background.color
            self.timeLabel.textColor = TrinapAsset.black.color
            self.timeLabel.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
        }
    }
}

//
//  ReservationDetailViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/30.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ReservationDetailViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var backButton = UIButton().than {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = TrinapAsset.black.color
    }
    
    private lazy var titleLabel = UILabel().than {
        $0.text = "예약 정보"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 24)
        $0.textColor = TrinapAsset.black.color
    }
    
    private lazy var statusButton = TrinapButton(style: .disabled).than {
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        $0.setTitle("예약 정보", for: .normal)
    }
    
    private lazy var reservationInformationView = InformationStackView(descriptionAlignment: .trailing)
    private lazy var photographerUserView = ReservationUserView(userType: .photographer)
    private lazy var divider = Divider()
    private lazy var customerUserView = ReservationUserView(userType: .customer)
    private lazy var reservationButtonView = ReservationButtonView()
    
    // MARK: - Properties
    private let viewModel: ReservationDetailViewModel
    
    // MARK: - Initializers
    init(viewModel: ReservationDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubviews([
            backButton,
            titleLabel,
            statusButton,
            reservationInformationView,
            photographerUserView,
            divider,
            customerUserView,
            reservationButtonView
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(backButton.snp.bottom).offset(20)
        }
        
        statusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        reservationInformationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        photographerUserView.snp.makeConstraints { make in
            make.top.equalTo(reservationInformationView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(photographerUserView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        customerUserView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        reservationButtonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
    }
    
    override func bind() {
        super.bind()
        
        let backButtonTap = backButton.rx.tap.asSignal()
        
        let input = ReservationDetailViewModel.Input(
            backButtonTap: backButtonTap,
            customerUserViewTap: customerUserView.tap,
            photographerUserViewTap: photographerUserView.tap,
            primaryButtonTap: reservationButtonView.primaryButtonTap.asObservable(),
            secondaryButtonTap: reservationButtonView.secondaryButtonTap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.reservation
            .bind(onNext: { [weak self] reservation in self?.configureUI(reservation) })
            .disposed(by: disposeBag)
        
        output.reservationStatus
            .bind(onNext: { [weak self] reservationStatus in self?.configureStatus(reservationStatus) })
            .disposed(by: disposeBag)
    }
}

// MARK: - Privates
private extension ReservationDetailViewController {
    
    func configureUI(_ reservation: Reservation) {
        reservationInformationView.configureInformations([
            Information(key: "날짜", value: reservation.reservationStartDate.toString(type: .yearAndMonthAndDate)),
            Information(key: "시간", value: reservation.reservationStartDate.toString(format: "HH시 mm분")),
            Information(key: "장소", value: reservation.location)
        ])
        
        photographerUserView.setUser(reservation.photographerUser)
        customerUserView.setUser(reservation.customerUser)
    }
    
    func configureStatus(_ status: ReservationStatusConvertible) {
        configureReservationStatusConfigurations(status)
    }
    
    func configureReservationStatusConfigurations(_ statusConvertible: ReservationStatusConvertible) {
        let configurations = statusConvertible.convert()
        
        statusButton.setTitle(configurations.status.title, for: .normal)
        statusButton.fill = configurations.status.fillType
        statusButton.style = configurations.status.style
        
        if let primaryContent = configurations.primary {
            reservationButtonView.setPrimaryContent(
                title: primaryContent.title,
                fillType: primaryContent.fillType,
                style: primaryContent.style
            )
        } else {
            reservationButtonView.removePrimaryButton()
        }
        
        if let secondaryContent = configurations.secondary {
            reservationButtonView.setSecondaryContent(
                title: secondaryContent.title,
                fillType: secondaryContent.fillType,
                style: secondaryContent.style
            )
        } else {
            reservationButtonView.removeSecondaryButton()
        }
    }
}

//
//  TrinapAlert.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/04.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than
import SnapKit
import RxSwift

final class TrinapAlert: BaseViewController {
    
    // MARK: UI
    private lazy var alertView = UIView().than {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = TrinapAsset.white.color
    }
    
    private lazy var alertTitleLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
    
    private lazy var timeLabel = UILabel().than {
        $0.textColor = TrinapAsset.primary.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var subtitleLabel = UILabel().than {
        $0.textColor = TrinapAsset.subtext.color
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
    }
    
    private lazy var buttonStack = UIStackView().than {
        $0.distribution = .fillEqually
        $0.spacing = trinapOffset
        $0.alignment = .fill
    }
    
    // MARK: Properties
    private var dismissCompletion: (() -> Void)?
    private var width = 300.0
    private var height = 200.0
    
    // MARK: Initializers
    init(title: String, timeText: String?, subtitle: String) {
        super.init()
        alertTitleLabel.text = title
        subtitleLabel.text = subtitle
        configureTimeLabel(timeText: timeText)
    }
    
    init(
        title: String,
        timeText: String?,
        subtitle: String,
        size: CGSize
    ) {
        super.init()
        alertTitleLabel.text = title
        subtitleLabel.text = subtitle
        configureTimeLabel(timeText: timeText)
        self.width = size.width
        self.height = size.height
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func showAlert(
        navigationController: UINavigationController?,
        completion: (() -> Void)? = nil
    ) {
        guard let navigationController else { return }
        self.modalPresentationStyle = .overCurrentContext
        navigationController.present(self, animated: false, completion: nil)
        dismissCompletion = completion
    }
    
    func addAction(
        title: String,
        style: TrinapButton.ColorType,
        completion: (() -> Void)? = nil
    ) {
        let button = TrinapButton(style: style, fillType: .fill)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        buttonStack.addArrangedSubview(button)
        
        button.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                self.dismiss(animated: false)
                completion?()
                owner.dismissCompletion?()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(alertView)
        
        self.alertView.addSubviews([
            alertTitleLabel,
            subtitleLabel,
            buttonStack
        ])
    }
    
    override func configureConstraints() {
        alertView.snp.makeConstraints { [weak self] make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(self?.width ?? 300)
            make.height.equalTo(self?.height ?? 200)
        }
        
        alertTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(buttonStack.snp.top).offset(-24)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(trinapOffset * 2)
            make.bottom.equalTo(alertView.snp.bottom).offset(-2 * trinapOffset)
            make.height.equalTo(48)
        }
    }
    
    override func configureAttributes() {
        self.view.backgroundColor = TrinapAsset.gray40.color.withAlphaComponent(0.7)
    }
    
    override func bind() {}

    private func configureTimeLabel(timeText: String?) {
        guard let timeText else { return }
        self.view.addSubview(timeLabel)
        timeLabel.text = timeText
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(alertTitleLabel.snp.bottom).offset(2 * trinapOffset)
        }
    }
}

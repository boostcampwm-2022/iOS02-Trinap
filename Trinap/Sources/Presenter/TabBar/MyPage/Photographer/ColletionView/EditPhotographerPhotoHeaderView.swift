//
//  EditPhotographerPhotoHeaderView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class EditPhotographerPhotoHeaderView: BaseCollectionReusableView {
    private lazy var editButton = TrinapButton(style: .black, fillType: .border, isCircle: true)
    
    override func configureHierarchy() {
        self.addSubview(editButton)
    }
    
    override func configureConstraints() {
        editButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(trinapOffset * 2)
        }
    }
    
    override func configureAttributes() {
        editButton.setTitle("포트폴리오 편집", for: .normal)
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

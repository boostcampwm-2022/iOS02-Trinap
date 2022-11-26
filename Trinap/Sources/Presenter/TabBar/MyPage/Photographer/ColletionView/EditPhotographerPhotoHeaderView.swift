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

@objc protocol EditPhotographerPhotoHeaderViewDelegate {
    @objc optional func didTapButton()
}

final class EditPhotographerPhotoHeaderView: BaseCollectionReusableView {
    weak var delegate: EditPhotographerPhotoHeaderViewDelegate?
    
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

final class EditPhotographerPhotoHeaderViewProxy: DelegateProxy<EditPhotographerPhotoHeaderView,EditPhotographerPhotoHeaderViewDelegate>, DelegateProxyType, EditPhotographerPhotoHeaderViewDelegate {
    
    static func registerKnownImplementations() {
        self.register { headerView -> EditPhotographerPhotoHeaderViewProxy in
            EditPhotographerPhotoHeaderViewProxy(parentObject: headerView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: EditPhotographerPhotoHeaderView) -> EditPhotographerPhotoHeaderViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: EditPhotographerPhotoHeaderViewDelegate?, to object: EditPhotographerPhotoHeaderView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: EditPhotographerPhotoHeaderView {
    var rxdelegate: DelegateProxy<EditPhotographerPhotoHeaderView, EditPhotographerPhotoHeaderViewDelegate> {
        return EditPhotographerPhotoHeaderViewProxy.proxy(for: self.base)
    }
    
    var rxEdit: Observable<Void> {
        return rxdelegate.sentMessage(#selector(EditPhotographerPhotoHeaderViewDelegate.didTapButton)).map { _ in }
    }
}

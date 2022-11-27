//
//  BaseCollectionReusableView.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

@objc protocol BaseCollectionReusableViewDelegate {
    @objc optional func didTapButton()
}

class BaseCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    weak var delegate: BaseCollectionReusableViewDelegate?
    
    let disposeBag = DisposeBag()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureHierarchy()
        configureConstraints()
        bind()
    }
    
    func configureHierarchy() {}
    func configureConstraints() {}
    func configureAttributes() {}
    func bind() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is called.")
    }
}

final class BaseCollectionReusableViewProxy: DelegateProxy<BaseCollectionReusableView, BaseCollectionReusableViewDelegate>, DelegateProxyType, BaseCollectionReusableViewDelegate {
    
    static func registerKnownImplementations() {
        self.register { reusableView -> BaseCollectionReusableViewProxy in
            BaseCollectionReusableViewProxy(parentObject: reusableView, delegateProxy: self)
        }
    }
    static func currentDelegate(for object: BaseCollectionReusableView) -> BaseCollectionReusableViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: BaseCollectionReusableViewDelegate?, to object: BaseCollectionReusableView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: BaseCollectionReusableView {
    var rxdelegate: DelegateProxy<BaseCollectionReusableView, BaseCollectionReusableViewDelegate> {
        return BaseCollectionReusableViewProxy.proxy(for: self.base)
    }
    
    var rxTap: Observable<Void> {
        return rxdelegate.sentMessage(#selector(BaseCollectionReusableViewDelegate.didTapButton)).map { _ in }
    }
}

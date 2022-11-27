//
//  BaseCollectionViewCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

@objc protocol BaseCollectionViewCellDelegate {
    @objc optional func didTapButton()
}

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    weak var delegate: BaseCollectionViewCellDelegate?
    
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

final class BaseCollectionViewCellProxy: DelegateProxy<BaseCollectionViewCell, BaseCollectionViewCellDelegate>, DelegateProxyType, BaseCollectionViewCellDelegate {
    
    static func registerKnownImplementations() {
        self.register { collectionViewCell -> BaseCollectionViewCellProxy in
            BaseCollectionViewCellProxy(parentObject: collectionViewCell, delegateProxy: self)
        }
    }
    static func currentDelegate(for object: BaseCollectionViewCell) -> BaseCollectionViewCellDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: BaseCollectionViewCellDelegate?, to object: BaseCollectionViewCell) {
        object.delegate = delegate
    }
}

extension Reactive where Base: BaseCollectionViewCell {
    var rxdelegate: DelegateProxy<BaseCollectionViewCell, BaseCollectionViewCellDelegate> {
        return BaseCollectionViewCellProxy.proxy(for: self.base)
    }
    
    var rxTap: Observable<Void> {
        return rxdelegate.sentMessage(#selector(BaseCollectionViewCellDelegate.didTapButton)).map { _ in }
    }
}

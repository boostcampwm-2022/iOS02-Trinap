//
//  ObservableConvertibleType+Driver.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableConvertibleType {
    
    /**
     Converts observable sequence to `Driver` trait.
     
     - parameter onErrorPublishError: Publish error to given stream.
     - returns: empty array.
     */
    func asDriver(onErrorAcceptTo relay: PublishRelay<Error>, justReturn element: Element) -> Driver<Element> {
        let source = self
            .asDriver(onErrorRecover: { error in
                relay.accept(error)
                return .just(element)
            })
        
        return source
    }
}

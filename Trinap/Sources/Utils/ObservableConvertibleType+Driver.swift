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
     
    - parameter onErrorPresentAlertTo: Coordinator which alert will present.
    - returns: `element`.
    */
    func asDriver(
        onErrorPresentAlertTo coordinator: Coordinator?,
        message: String? = .errorDetected,
        andReturn element: Element
    ) -> Driver<Element> {
        let source = self
            .asDriver(onErrorRecover: { error in
                coordinator?.presentErrorAlert(message: error.localizedDescription)
                return .just(element)
            })
        
        return source
    }
    
    /**
    Converts observable sequence to `Driver` trait.

    - parameters:
      - onErrorPresentAlertTo: Coordinator which alert will present.
      - message: Alert message.
      - element: Value when error detected.
      - action: Alert action

    - returns: `element`.
    */
    func asDriver(
        onErrorPresentAlertTo coordinator: Coordinator?,
        message: String? = .errorDetected,
        andReturn element: Element,
        andPerform action: @escaping () -> Void
    ) -> Driver<Element> {
        let source = self
            .asDriver(onErrorRecover: { error in
                coordinator?.presentErrorAlert(message: error.localizedDescription, handler: action)
                return .just(element)
            })
        
        return source
    }
}

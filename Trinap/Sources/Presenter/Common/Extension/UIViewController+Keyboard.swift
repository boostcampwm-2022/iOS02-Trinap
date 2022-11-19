//
//  UIView+Keyboard.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa

extension UIView {
    
    /// 키보드가 나타날 때 `CGRect`를 방출합니다.
    /// `CGRect`는 키보드의 크기를 나타냅니다.
    var keyboardWillShowObserver: Signal<CGRect> {
        return NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map(\.userInfo)
            .compactMap { ($0?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .asSignal(onErrorJustReturn: .zero)
    }
    
    /// 키보드가 숨겨질 때 `Void` 이벤트를 방출합니다.
    var keyboardWillHideObserver: Signal<Void> {
        return NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { _ in return }
            .asSignal(onErrorJustReturn: ())
    }
}

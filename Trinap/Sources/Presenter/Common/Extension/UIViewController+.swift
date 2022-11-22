//
//  UIViewController+.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// offset 기본 단위
    var trinapOffset: CGFloat {
        return UIScreen.main.bounds.width / 50
    }
    
    func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        // 기본값이 true이면 제스쳐 발동시 터치 이벤트가 뷰로 전달x
        // 즉 제스쳐가 동작하면 뷰의 터치이벤트는 발생하지 않는것 false면 둘 다 작동한다는 뜻
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension UIView {
    
    /// offset 기본 단위 
    var trinapOffset: CGFloat {
        return UIScreen.main.bounds.width / 50
    }
}

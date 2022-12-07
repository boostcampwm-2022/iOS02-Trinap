//
//  UINavigationController+.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /**
     backButton 타이틀 제거
    TintColor black으로 설정
     */
    func pushViewControllerHideBottomBar(rootViewController: UIViewController, isNavigationBarHidden: Bool = false, animated: Bool) {
        self.navigationBar.isHidden = isNavigationBarHidden
        self.navigationBar.topItem?.title = ""
        self.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.pushViewController(rootViewController, animated: animated)
        self.viewControllers.first?.hidesBottomBarWhenPushed = false
    }
    
    func setLeftArrowBackButton() {
        let backButtonImage = UIImage(systemName: "arrow.left")?
            .withTintColor(TrinapAsset.black.color, renderingMode: .alwaysOriginal)
        
        self.navigationBar.backIndicatorImage = backButtonImage
        self.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        self.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func setShadowImage() {
        self.navigationBar.shadowImage = nil
    }
}

//
//  SceneDelegate.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/14.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootViewController = MainViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

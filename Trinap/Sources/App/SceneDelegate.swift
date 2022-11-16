//
//  SceneDelegate.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/14.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    let disposeBag = DisposeBag()
    let repository = DefaultChatroomRepository(firebaseStoreService: DefaultFireBaseStoreService())
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator?.start()
        
        repository.fetch()
            .subscribe(
                onSuccess: { chatrooms in
                    Logger.printArray(chatrooms)
                },
                onFailure: { error in
                    Logger.print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}

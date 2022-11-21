//
//  TabBarPageType.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
import UIKit

enum TabBarPageType: Int, CaseIterable {
    case main = 0, chat, reservation, myPage
    
    // MARK: - Properties
    var tabBarItem: UITabBarItem {
        switch self {
        case .main:
            return UITabBarItem(
                title: "홈",
                image: TrinapAsset.home.image,
                selectedImage: TrinapAsset.selectHome.image
            )
        case .chat:
            return UITabBarItem(
                title: "채팅",
                image: TrinapAsset.chat.image,
                selectedImage: TrinapAsset.selectedChat.image
            )
        case .reservation:
            return UITabBarItem(
                title: "예약 내역",
                image: TrinapAsset.reservation.image,
                selectedImage: TrinapAsset.selectedReservation.image
            )
        case .myPage:
            return UITabBarItem(
                title: "마이페이지",
                image: TrinapAsset.user.image,
                selectedImage: TrinapAsset.selectUser.image
            )
        }
    }
}

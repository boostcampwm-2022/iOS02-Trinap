//
//  TabBarPageCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
import UIKit

enum TabBarPageCase: CaseIterable {
    case main
    case chat
    case reservation
    case myPage
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .main
        case 1:
            self = .chat
        case 2:
            self = .reservation
        case 3:
            self = .myPage
        default:
            return nil
        }
    }
    
    var pageOrderNumber: Int {
        switch self {
        case .main:
            return 0
        case .chat:
            return 1
        case .reservation:
            return 2
        case .myPage:
            return 3
        }
    }
    
    var pageTitle: String {
        switch self {
        case .main:
            return "홈"
        case .chat:
            return "채팅"
        case .reservation:
            return "예약 내역"
        case .myPage:
            return "마이페이지"
        }
    }
    
    func tabIcon() -> UIImage {
        switch self {
        case .main:
            return TrinapAsset.home.image
        case .chat:
            return TrinapAsset.chat.image
        case .reservation:
            return TrinapAsset.reservation.image
        case .myPage:
            return TrinapAsset.user.image
        }
    }
    
    func selectedTabIcon() -> UIImage {
        switch self {
        case .main:
            return TrinapAsset.selectHome.image
        case .chat:
            return TrinapAsset.selectedChat.image
        case .reservation:
            return TrinapAsset.selectedReservation.image
        case .myPage:
            return TrinapAsset.selectUser.image
        }
    }
}

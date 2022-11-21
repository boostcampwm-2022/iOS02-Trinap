//
//  TabBarPageCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

enum TabBarPageCase: Int, CaseIterable {
    case main = 0, chat, reservation, myPage

    // MARK: - Properties
    var pageOrderNumber: Int {
        return self.rawValue
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

    // MARK: - Methods
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

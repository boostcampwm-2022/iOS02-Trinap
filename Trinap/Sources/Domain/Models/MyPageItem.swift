//
//  MyPageItem.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum MyPageSection: CaseIterable, Hashable {
    case profile
    case photograhper
    case setting
    case etc
    
    var title: String? {
        switch self {
        case .photograhper:
            return "작가 설정"
        case .setting:
            return "사용자 설정"
        case .etc:
            return "기타"
        case .profile:
            return nil
        }
    }
}

enum MyPageCellType: Hashable {
    case profile(user: User)
    case phohographerProfile
    case photographerDate
    case photographerExposure(isExposure: Bool)
    case userAlarm
    case userImageAuthorization
    case userLocation
    case userBlock
    case contact
    case version(version: String)
    case opensource
    case logout
    case dropout
    
    var title: String {
        switch self {
        case .phohographerProfile:
            return "작가 프로필 설정"
        case .photographerDate:
            return "작가 영엉빌 설정"
        case .photographerExposure:
            return "작가 프로필 노출"
        case .userAlarm:
            return "알람 설정"
        case .userImageAuthorization:
            return "이미지 권한 설정"
        case .userLocation:
            return "위치정보 설정"
        case .userBlock:
            return "차단목록 관리"
        case .contact:
            return "직접 문의"
        case .version:
            return "오픈버전 정보"
        case .opensource:
            return "오픈소스 라이선스"
        case .logout:
            return "로그아웃"
        case .dropout:
            return "탈퇴하기"
        default:
            return ""
        }
    }
}

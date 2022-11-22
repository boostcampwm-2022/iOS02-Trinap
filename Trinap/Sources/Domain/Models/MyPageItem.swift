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
    case nofiticationAuthorization
    case photoAuthorization
    case locationAuthorization
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
            return "작가 영업일 설정"
        case .photographerExposure:
            return "작가 프로필 노출"
        case .nofiticationAuthorization:
            return "알람 설정"
        case .photoAuthorization:
            return "이미지 권한 설정"
        case .locationAuthorization:
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
    
    var url: URL? {
        switch self {
        case .nofiticationAuthorization:
            return URL(string: URLConstants.notificationAuthorization)
        case .photoAuthorization:
            return URL(string: URLConstants.photoAuthorization)
        case .locationAuthorization:
            return URL(string: URLConstants.locationAuthorization)
        default:
            return nil
        }
    }
}

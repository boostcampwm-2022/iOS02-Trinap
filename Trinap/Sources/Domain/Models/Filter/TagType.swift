//
//  TagType.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

/// 메인화면 필터, 작가의 프로필의 태그 설정할 때 사용
enum TagType: String, CaseIterable {
    
    case all = "전체"
    case profile = "프로필 사진"
    case instagram = "인스타"
    case pet = "반려동물"
    case wedding = "웨딩 촬영"
    case filmCamera = "필카감성"
    
    var title: String {
        switch self {
        case .all:
            return "전체"
        case .profile:
            return "프로필 사진"
        case .instagram:
            return "인스타"
        case .pet:
            return "반려동물"
        case .wedding:
            return "웨딩 촬영"
        case .filmCamera:
            return "필카 감성"
        }
    }
}

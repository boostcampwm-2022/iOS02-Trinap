//
//  ReservationStatusConfigurations.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct ReservationStatusConfigurations {
    
    let status: Configuration
    let primary: Configuration?
    let secondary: Configuration?
    
    static var onError: Self {
        return Self(
            status: Configuration(title: "오류", fillType: .fill, style: .error),
            primary: Configuration(title: "오류가 발생했습니다.", fillType: .fill, style: .disabled),
            secondary: nil
        )
    }
}

extension ReservationStatusConfigurations {
    
    struct Configuration {
        
        let title: String
        let fillType: TrinapButton.FillType
        let style: TrinapButton.ColorType
    }
}

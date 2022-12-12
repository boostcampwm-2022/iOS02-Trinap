//
//  ReservationError.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/04.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

struct ReservationError: ReservationStatusConvertible, ReservationUseCaseExecutable {
    
    private typealias Configurations = ReservationStatusConfigurations
    private typealias Configuration = ReservationStatusConfigurations.Configuration
    
    func convert() -> ReservationStatusConfigurations {
        return Configurations(
            status: Configuration(title: "오류 발생", fillType: .fill, style: .secondary),
            primary: Configuration(title: "오류가 발생하였습니다.", fillType: .fill, style: .disabled),
            secondary: nil
        )
    }
}

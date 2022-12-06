//
//  CreateReservationUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateReservationUseCase {

    // MARK: Methods
    func create(
        photographerUserId: String,
        startDate: Date,
        endDate: Date,
        coordinate: Coordinate
    ) -> Observable<String>
}

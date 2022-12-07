//
//  DefaultCreateReservationUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultCreateReservationUseCase: CreateReservationUseCase {
    
    // MARK: Properties
    private let reservationRepository: ReservationRepository
    
    // MARK: Initializers
    init(reservationRepository: ReservationRepository) {
        self.reservationRepository = reservationRepository
    }
    
    // MARK: Methods
    func create(
        photographerUserId: String,
        startDate: Date,
        endDate: Date,
        coordinate: Coordinate
    ) -> Observable<String> {
        
        reservationRepository.create(
            photographerUserId: photographerUserId,
            startDate: startDate,
            endDate: endDate,
            coordinate: coordinate
        )
    }
}

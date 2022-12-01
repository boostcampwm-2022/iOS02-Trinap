//
//  DefaultFetchReservationUserTypeUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class DefaultFetchReservationUserTypeUseCase: FetchReservationUserTypeUseCase {
    
    // MARK: - Properties
    private let reservationRepository: ReservationRepository
    
    // MARK: - Initializers
    init(reservationRepository: ReservationRepository) {
        self.reservationRepository = reservationRepository
    }
    
    // MARK: - Methods
    func execute(customerId: String, photographerId: String) -> Reservation.UserType? {
        return reservationRepository.fetchUserType(customerId: customerId, photographerId: photographerId)
    }
}

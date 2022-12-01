//
//  DefaultFetchReservationUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

final class DefaultFetchReservationUseCase: FetchReservationUseCase {
    
    // MARK: - Properties
    private let reservationRepository: ReservationRepository
    private let userRepository: UserRepository
    private let mapRepository: MapRepository
    
    // MARK: - Initializers
    init(
        reservationRepository: ReservationRepository,
        userRepository: UserRepository,
        mapRepository: MapRepository
    ) {
        self.reservationRepository = reservationRepository
        self.userRepository = userRepository
        self.mapRepository = mapRepository
    }
    
    // MARK: - Methods
    func execute(reservationId: String) -> Observable<Reservation> {
        return reservationRepository.fetchReservation(reservationId: reservationId)
            .withUnretained(self)
            .flatMap { $0.collectReservationFields(from: $1) }
    }
}

// MARK: - Privates
private extension DefaultFetchReservationUseCase {
    
    func collectReservationFields(from mapper: Reservation.Mapper) -> Observable<Reservation> {
        let coordinate = Coordinate(lat: mapper.latitude, lng: mapper.longitude)
        
        return Observable.zip(
            fetchUser(userId: mapper.customerUserId),
            fetchUser(userId: mapper.photographerUserId),
            fetchLocation(coordinate: coordinate)
        )
        .map { customer, photographer, location in
            return Reservation(
                reservationId: mapper.reservationId,
                customerUser: customer,
                photographerUser: photographer,
                reservationStartDate: mapper.reservationStartDate,
                reservationEndDate: mapper.reservationEndDate,
                location: location,
                status: mapper.status
            )
        }
    }
    
    func fetchUser(userId: String) -> Observable<User> {
        return userRepository.fetch(userId: userId)
    }
    
    func fetchLocation(coordinate: Coordinate) -> Observable<String> {
        return mapRepository.fetchLocationName(using: coordinate)
    }
}

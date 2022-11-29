//
//  DefaultFetchReservationPreviewsUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchReservationPreviewsUseCase: FetchReservationPreviewsUseCase {
    
    // MARK: Properties
    private let reservationRepository: ReservationRepository
    private let userRepository: UserRepository
    private let mapRepository: MapRepository
    
    // MARK: Initializer
    init(
        reservationRepository: ReservationRepository,
        userRepository: UserRepository,
        mapRepository: MapRepository
    ) {
        self.reservationRepository = reservationRepository
        self.userRepository = userRepository
        self.mapRepository = mapRepository
    }
    
    // MARK: Methods
    func fetchSentReservationPreviews() -> Observable<[Reservation.Preview]> {
        return reservationRepository.fetchSentReservations()
            .withUnretained(self)
            .flatMap { $0.fetchUsersAndMapToPreviews(mappers: $1) }
    }
    
    func fetchReceivedReservationPreviews() -> Observable<[Reservation.Preview]> {
        return reservationRepository.fetchReceivedReservations()
            .withUnretained(self)
            .flatMap { $0.fetchUsersAndMapToPreviews(mappers: $1) }
    }
}

// MARK: - Privates
private extension DefaultFetchReservationPreviewsUseCase {
    
    func fetchUsersAndMapToPreviews(mappers: [Reservation.Mapper]) -> Observable<[Reservation.Preview]> {
        return fetchUsers(from: mappers).withUnretained(self) { owner, users in
            return owner.mapToReservationPreview(mappers: mappers, users: users)
        }
    }
    
    func fetchUsers(from reservations: [Reservation.Mapper]) -> Observable<[User]> {
        let customerUserIds = reservations.map { $0.customerUserId }
        let photographerUserIds = reservations.map { $0.photographerUserId }
        let userIds = (customerUserIds + photographerUserIds).removingDuplicates()
        
        return userRepository.fetchUsers(userIds: userIds)
    }
    
    func mapToReservationPreview(mappers: [Reservation.Mapper], users: [User]) -> [Reservation.Preview] {
        var previews: [Reservation.Preview] = []
        
        mappers.forEach { mapper in
            var customerUser: User?
            var photographerUser: User?
            
            users.forEach { user in
                if mapper.customerUserId == user.userId {
                    customerUser = user
                } else if mapper.photographerUserId == user.userId {
                    photographerUser = user
                }
            }
            
            if let customerUser, let photographerUser {
                let preview = mapUserMapperToPreview(
                    customerUser: customerUser,
                    photographerUser: photographerUser,
                    mapper: mapper
                )
                previews.append(preview)
            }
        }
        
        return previews
    }
    
    func mapUserMapperToPreview(
        customerUser: User,
        photographerUser: User,
        mapper: Reservation.Mapper
    ) -> Reservation.Preview {
        return Reservation.Preview(
            reservationId: mapper.reservationId,
            customerUser: customerUser,
            photographerUser: photographerUser,
            reservationStartDate: mapper.reservationStartDate,
            status: mapper.status
        )
    }
}

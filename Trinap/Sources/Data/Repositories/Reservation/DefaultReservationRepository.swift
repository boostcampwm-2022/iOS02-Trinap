//
//  DefaultReservationRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultReservationRepository: ReservationRepository {
        
    // MARK: Properties
    private let fireStore: FireStoreService
    private let keychainManager: TokenManager
    
    init(
        firebaseStoreService: FireStoreService,
        keychainManager: TokenManager = KeychainTokenManager()
    ) {
        self.fireStore = firebaseStoreService
        self.keychainManager = keychainManager
    }
    
    // MARK: Methods
    func fetchUserType(customerId: String, photographerId: String) -> Reservation.UserType? {
        guard let userId = keychainManager.getToken(with: .userId) else { return nil }
        
        if customerId == userId {
            return .customer
        } else if photographerId == userId {
            return .photographer
        } else {
            return nil
        }
    }
    
    func fetchReceivedReservations() -> Observable<[Reservation.Mapper]> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStore.getDocument(
            collection: .reservations,
            field: "photographerUserId",
            in: [userId]
        )
        .map { $0.compactMap { $0.toObject(ReservationDTO.self)?.toMapper() } }
        .asObservable()
    }
    
    func fetchSentReservations() -> Observable<[Reservation.Mapper]> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStore.getDocument(
            collection: .reservations,
            field: "customerUserId",
            in: [userId]
        )
        .map { $0.compactMap { $0.toObject(ReservationDTO.self)?.toMapper() } }
        .asObservable()
    }
    
    func create(reservation: Reservation, coordinate: Coordinate) -> Observable<Void> {
        let dto = ReservationDTO(reservation: reservation, coordinate: coordinate)
        return fireStore.createDocument(
            collection: .reservations,
            document: dto.reservationId,
            values: dto.asDictionary ?? [:]
        )
        .asObservable()
    }
    
    func create(
        photographerUserId: String,
        startDate: Date,
        endDate: Date,
        coordinate: Coordinate
    ) -> Observable<Void> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(LocalError.tokenError)
        }
        
        let dto = ReservationDTO(
            reservationId: UUID().uuidString,
            customerUserId: userId,
            photographerUserId: photographerUserId,
            reservationStartDate: startDate.toString(type: .timeStamp),
            reservationEndDate: startDate.toString(type: .timeStamp),
            latitude: coordinate.lat,
            longitude: coordinate.lng,
            status: .request
        )
        guard let values = dto.asDictionary else {
            return .error(LocalError.structToDictionaryError)
        }
        
        return fireStore.createDocument(
            collection: .reservations,
            document: dto.reservationId,
            values: values
        )
        .asObservable()
    }
    
    func fetchReservation(reservationId: String) -> Observable<Reservation.Mapper> {
        return fireStore.getDocument(
            collection: .reservations,
            document: reservationId
        )
        .compactMap { $0.toObject(ReservationDTO.self)?.toMapper() }
        .asObservable()
    }
    
    func updateReservationStatus(reservationId: String, status: Reservation.Status) -> Observable<Void> {
        let values = ["status": status.rawValue]
        
        return fireStore.updateDocument(collection: .reservations, document: reservationId, values: values)
            .asObservable()
    }
}

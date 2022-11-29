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
    func fetchReceivedReservations() -> Observable<[Reservation.Mapper]> {
        guard let userId = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStore.getDocument(
            collection: .reservations,
            field: "photographerUserId",
            condition: [userId]
        )
        .map { $0.compactMap { $0.toObject(ReservationDTO.self)?.toMapper() } }
        .asObservable()
    }
    
    func fetchSentReservations() -> Observable<[Reservation.Mapper]> {
        guard let token = keychainManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStore.getDocument(
            collection: .reservations,
            field: "customerUserId",
            condition: [token]
        )
        .map { $0.compactMap { $0.toObject(ReservationDTO.self)?.toMapper() } }
        .asObservable()
    }
    
    // document가 reservationId라고 가정하고 진행함
//    func fetchDetail(reservationId: String) -> Observable<Reservation> {
//        return fireStore.getDocument(
//            collection: .reservations,
//            document: reservationId
//        )
//        .compactMap { $0.toObject(ReservationDTO.self)?.toModel() }
//        .asObservable()
//    }
//
//    func addReservation(reservation: Reservation) -> Observable<Bool> {
//        guard let data = reservation.asDictionary else { return Observable.just(false) }
//        return fireStore
//            .createDocument(
//                collection: .reservations,
//                document: reservation.reservationId,
//                values: data
//            )
//            .asObservable()
//            .map { true }
//    }
//
//    func deleteReservation(reservationId: String) -> Observable<Void> {
//        return fireStore.deleteDocument(
//            collection: .reservations,
//            document: reservationId
//        )
//        .asObservable()
//    }
//
//    func updateState(reservationId: String, state: Reservation.Status) -> Observable<Void> {
//        return fireStore.updateDocument(
//            collection: .reservations,
//            document: reservationId,
//            values: ["status": state.rawValue]
//        )
//        .asObservable()
//    }
}

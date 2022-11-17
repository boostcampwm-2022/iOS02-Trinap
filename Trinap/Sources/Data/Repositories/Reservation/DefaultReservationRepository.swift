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
        keychainManager: TokenManager
    ) {
        self.fireStore = firebaseStoreService
        self.keychainManager = keychainManager
    }
    
    // MARK: Methods
    func fetchPhotographerReservations() -> Observable<[Reservation]> {
        guard let token = keychainManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStore.getDocument(
            collection: .reservations,
            field: "photograhperUserId",
            condition: [token]
        )
        .map { datas in
            datas.compactMap { $0.toObject(ReservationDTO.self)?.toModel() }
        }
        .asObservable()
    }
    
    func fetchCustomerReservations() -> Observable<[Reservation]> {
        guard let token = keychainManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStore.getDocument(
            collection: .reservations,
            field: "customerUserId",
            condition: [token]
        )
        .map { datas in
            datas.compactMap { $0.toObject(ReservationDTO.self)?.toModel() }
        }
        .asObservable()
    }
    
    // document가 reservationId라고 가정하고 진행함
    func fetchDetail(reservationId: String) -> Observable<Reservation> {
        return fireStore.getDocument(
            collection: .reservations,
            document: reservationId
        )
        .compactMap { $0.toObject(ReservationDTO.self)?.toModel() }
        .asObservable()
    }
    
    func addReservation(reservation: Reservation) -> Observable<Bool> {
        guard let data = reservation.asDictionary else { return Observable.just(false) }
        return fireStore
            .createDocument(
                collection: .reservations,
                document: reservation.reservationId,
                values: data
            )
            .asObservable()
            .map { true }
    }
    
    func deleteReservation(reservationId: String) -> Observable<Void> {
        return fireStore.deleteDocument(
            collection: .reservations,
            document: reservationId
        )
        .asObservable()
    }
    
    func updateState(reservationId: String, state: Reservation.State) -> Observable<Void> {
        return fireStore.updateDocument(
            collection: .reservations,
            document: reservationId,
            values: ["status": state.rawValue]
        )
        .asObservable()
    } 
}

//
//  DefaultReservationRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultReservationRepository: ReservationRepository {
    
    enum ReservationState: String {
        case request
        case confirm
        case done
        case cancel
    }
    
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
            datas.compactMap { $0.toObject(type: ReservationDTO.self)?.toEntity() }
        }
        .asObservable()
    }
    
    func fetchCustomerReservations() -> RxSwift.Observable<[Reservation]> {
        guard let token = keychainManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStore.getDocument(
            collection: .reservations,
            field: "customerUserId",
            condition: [token]
        )
        .map { datas in
            datas.compactMap { $0.toObject(type: ReservationDTO.self)?.toEntity() }
        }
        .asObservable()
    }
    
    // document가 reservationId라고 가정하고 진행함
    func fetchDetail(reservationId: String) -> Observable<Reservation> {
        return fireStore.getDocument(
            collection: .reservations,
            document: reservationId
        )
        .compactMap { $0.toObject(type: ReservationDTO.self)?.toEntity() }
        .asObservable()
    }
    
    func addReservation(reservation: Reservation) -> Observable<Bool> {
        guard let data = reservation.asDictionary else { return Observable.just(false) }
        return fireStore
            .createDocument(
                collection: .reservations,
                document: UUID().uuidString,
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
    
    func updateState(reservationId: String, state: ReservationState) -> Observable<Void> {
        return fireStore.updateDocument(
            collection: .reservations,
            document: reservationId,
            values: ["status": state.rawValue]
            )
            .asObservable()
    }
    
}

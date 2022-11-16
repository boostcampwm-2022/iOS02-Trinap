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
    
    // MARK: Properties
    private let fireStore: FirebaseStoreService
    private let keychainManager: KeychainTokenManager
    private let token: Token
    
    init(firebaseStoreService: FirebaseStoreService, keychainManager: KeychainTokenManager) {
        self.fireStore = firebaseStoreService
        self.keychainManager = keychainManager
        guard let token = keychainManager.getToken() else { return }
        self.token = token
    }
    
    // MARK: Methods
    func fetchPhotographerReservations() -> Observable<[Reservation]> {
        
        fireStore.getDocument(collection: "reservations", field: "photograhperUserId", condition: [token])
            .map { datas in
                datas.compactMap { $0.toObject(type: ReservationDTO.self)?.toEntity() }
            }
            .asObservable()
    }
    
    func fetchCustomerReservations() -> RxSwift.Observable<[Reservation]> {
        <#code#>
    }

    
    // document가 reservationId라고 가정하고 진행함
    func fetchDetail(reservationId: String) -> Observable<Reservation> {
        fireStore.getDocument(collection: "reservations", document: reservationId)
            .compactMap { $0.toObject(type: ReservationDTO.self)?.toEntity()}
            .asObservable()
    }
    
    func addReservation(reservation: Reservation) -> Observable<Bool> {
        guard let data = reservation.asDictionary else { return Observable.just(false) }
        return fireStore.createDocument(collection: "reservations", document: UUID().uuidString, values: data)
            .asObservable()
            .map { true }
    }
    
    func deleteReservation(reservationId: String) -> Observable<Void> {
        <#code#>
    }
    
    func updateState(reservationId: String, state: String) -> Observable<Void> {
        <#code#>
    }
    
    
}

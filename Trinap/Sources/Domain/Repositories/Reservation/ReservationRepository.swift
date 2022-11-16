//
//  ReservationRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol ReservationRepository {
    
    associatedtype ReservationState
    
    // MARK: Methods
    func fetchPhotographerReservations() -> Observable<[Reservation]>
    func fetchCustomerReservations() -> Observable<[Reservation]>
    func fetchDetail(reservationId: String) -> Observable<Reservation>
    func addReservation(reservation: Reservation) -> Observable<Bool>
    func deleteReservation(reservationId: String) -> Observable<Void>
    func updateState(reservationId: String, state: ReservationState) -> Observable<Void>
}

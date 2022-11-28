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
    
    // MARK: Methods
    func fetchReceivedReservations() -> Observable<[Reservation]>
    func fetchSentReservations() -> Observable<[Reservation]>
    func fetchDetail(reservationId: String) -> Observable<Reservation>
    func addReservation(reservation: Reservation) -> Observable<Bool>
    func deleteReservation(reservationId: String) -> Observable<Void>
    func updateState(reservationId: String, state: Reservation.State) -> Observable<Void>
}

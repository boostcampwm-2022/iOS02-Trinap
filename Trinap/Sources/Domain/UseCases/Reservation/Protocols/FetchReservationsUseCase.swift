//
//  FetchReservationsUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchReservationsUseCase {
    
    // MARK: Methods
    func fetchCustomerReservations() -> Observable<[Reservation]>
    func fetchPhotographerReservations() -> Observable<[Reservation]> 
}

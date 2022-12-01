//
//  FetchReservationPreviewsUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchReservationPreviewsUseCase {
    
    // MARK: Methods
    func fetchSentReservationPreviews() -> Observable<[Reservation.Preview]>
    func fetchReceivedReservationPreviews() -> Observable<[Reservation.Preview]> 
}

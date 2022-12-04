//
//  CancelReservationRequestUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/04.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol CancelReservationRequestUseCase {
    
    func execute(reservation: Reservation) -> Observable<Reservation>
}

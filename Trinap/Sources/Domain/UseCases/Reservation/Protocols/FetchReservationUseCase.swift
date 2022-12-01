//
//  FetchReservationUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol FetchReservationUseCase {
    
    func execute(reservationId: String) -> Observable<Reservation>
}

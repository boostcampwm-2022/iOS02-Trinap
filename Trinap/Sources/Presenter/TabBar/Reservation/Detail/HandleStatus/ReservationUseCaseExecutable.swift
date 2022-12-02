//
//  ReservationUseCaseExecutable.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol ReservationUseCaseExecutable {
    
    func executePrimaryAction() -> Observable<Reservation>?
    func executeSecondaryAction() -> Observable<Reservation>?
}

extension ReservationUseCaseExecutable {
    
    func executePrimaryAction() -> Observable<Reservation>? {
        return nil
    }
    
    func executeSecondaryAction() -> Observable<Reservation>? {
        return nil
    }
}

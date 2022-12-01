//
//  ReservationDetailViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/30.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class ReservationDetailViewModel: ViewModelType {
    
    struct Input {
        var backButtonTap: Signal<Void>
    }
    
    struct Output {
        var reservation: Observable<Reservation>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var reservationCoordinator: ReservationCoordinator?
    private let fetchReservationUseCase: FetchReservationUseCase
    private let reservationId: String
    
    // MARK: - Initializer
    init(
        reservationCoordinator: ReservationCoordinator?,
        fetchReservationUseCase: FetchReservationUseCase,
        reservationId: String
    ) {
        self.reservationCoordinator = reservationCoordinator
        self.fetchReservationUseCase = fetchReservationUseCase
        self.reservationId = reservationId
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.reservationCoordinator?.pop()
            })
            .disposed(by: disposeBag)
        
        return Output(reservation: fetchReservationUseCase.execute(reservationId: reservationId))
    }
}

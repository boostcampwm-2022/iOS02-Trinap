//
//  ReservationPreviewListViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift
import RxCocoa

final class ReservationPreviewListViewModel: ViewModelType {
    
    struct Input {
        var reservationType: Observable<ReservationFilter>
    }
    
    struct Output {
        var reservationPreviews: Driver<[Reservation.Preview]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ReservationCoordinator?
    private let fetchReservationPreviewsUseCase: FetchReservationPreviewsUseCase
    
    // MARK: - Initializer
    init(
        coordinator: ReservationCoordinator?,
        fetchReservationPreviewsUseCase: FetchReservationPreviewsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchReservationPreviewsUseCase = fetchReservationPreviewsUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let reservationPreviews = input.reservationType
            .withUnretained(self)
            .flatMap { $0.mapFilterToPreviews($1) }
        
        return Output(reservationPreviews: reservationPreviews.asDriver(onErrorJustReturn: []))
    }
}

// MARK: - Privates
private extension ReservationPreviewListViewModel {
    
    func mapFilterToPreviews(_ filter: ReservationFilter) -> Observable<[Reservation.Preview]> {
        switch filter {
        case .receive:
            return fetchReservationPreviewsUseCase.fetchReceivedReservationPreviews()
        case .send:
            return fetchReservationPreviewsUseCase.fetchSentReservationPreviews()
        }
    }
}

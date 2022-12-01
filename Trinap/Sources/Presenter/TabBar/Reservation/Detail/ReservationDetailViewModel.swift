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
    
    typealias ReservationStatus = ReservationStatusConvertible & ReservationUseCaseExecutable
    
    struct Input {
        var backButtonTap: Signal<Void>
        var primaryButtonTap: Observable<Void>
        var secondaryButtonTap: Observable<Void>
    }
    
    struct Output {
        var reservation: Observable<Reservation>
        var reservationStatus: Observable<ReservationStatus>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var reservationCoordinator: ReservationCoordinator?
    private let fetchReservationUseCase: FetchReservationUseCase
    private let fetchReservationUserTypeUseCase: FetchReservationUserTypeUseCase
    private let reservationId: String
    
    // MARK: - Initializer
    init(
        reservationCoordinator: ReservationCoordinator?,
        fetchReservationUseCase: FetchReservationUseCase,
        fetchReservationUserTypeUseCase: FetchReservationUserTypeUseCase,
        reservationId: String
    ) {
        self.reservationCoordinator = reservationCoordinator
        self.fetchReservationUseCase = fetchReservationUseCase
        self.fetchReservationUserTypeUseCase = fetchReservationUserTypeUseCase
        self.reservationId = reservationId
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.reservationCoordinator?.pop()
            })
            .disposed(by: disposeBag)
        
        let fetchReservation = fetchReservationUseCase.execute(reservationId: reservationId).share()
        let reservationStatus = fetchReservation
            .withUnretained(self) { owner, reservation in
                return owner.reservationStatus(reservation: reservation)
            }
            .share()
        
        executePrimaryAction(primaryButtonTap: input.primaryButtonTap, reservationStatus: reservationStatus)
            .bind(onNext: { reservation in
                Logger.print("Primary Executed: \(reservation)")
            })
            .disposed(by: disposeBag)
        
        executeSecondaryAction(secondaryButtonTap: input.secondaryButtonTap, reservationStatus: reservationStatus)
            .bind(onNext: { reservation in
                Logger.print("Secondary Executed: \(reservation)")
            })
            .disposed(by: disposeBag)
        
        return Output(
            reservation: fetchReservation,
            reservationStatus: reservationStatus
        )
    }
}

// MARK: - Privates
private extension ReservationDetailViewModel {
    
    func reservationStatus(reservation: Reservation) -> ReservationStatus {
        // TODO: - 에러 처리를 어떻게 하지 (후보: ReservationError: ReservationStatusConvertible, ReservationUseCaseExecutable)
        let userType = fetchReservationUserTypeUseCase.execute(
            customerId: reservation.customerUser.userId,
            photographerId: reservation.photographerUser.userId
        ) ?? .customer
        
        return reservationStatus(reservation: reservation, userType: userType)
    }
    
    func reservationStatus(
        reservation: Reservation,
        userType: Reservation.UserType
    ) -> ReservationStatus {
        switch reservation.status {
        case .request:
            return ReservationRequested(reservation: reservation, userType: userType)
        case .confirm:
            return ReservationConfirmed(reservation: reservation, userType: userType)
        case .done:
            return ReservationDone(reservation: reservation, userType: userType)
        case .cancel:
            return ReservationCancelled(reservation: reservation, userType: userType)
        }
    }
    
    func executePrimaryAction(
        primaryButtonTap: Observable<Void>,
        reservationStatus: Observable<ReservationStatus>
    ) -> Observable<Reservation> {
        let primaryAction = reservationStatus.flatMap { $0.executePrimaryAction() ?? .empty() }
        
        return primaryButtonTap.flatMap { return primaryAction }
    }
    
    func executeSecondaryAction(
        secondaryButtonTap: Observable<Void>,
        reservationStatus: Observable<ReservationStatus>
    ) -> Observable<Reservation> {
        let secondaryAction = reservationStatus.flatMap { $0.executeSecondaryAction() ?? .empty() }
        
        return secondaryButtonTap.flatMap { return secondaryAction }
    }
}

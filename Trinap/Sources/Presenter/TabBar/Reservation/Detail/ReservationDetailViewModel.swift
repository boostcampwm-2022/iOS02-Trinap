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
        var customerUserViewTap: Observable<Void>
        var photographerUserViewTap: Observable<Void>
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
    private var reservation: Reservation?
    private weak var reservationStatusFactory: ReservationStatusFactory?
    
    // MARK: - Initializer
    init(
        reservationCoordinator: ReservationCoordinator?,
        fetchReservationUseCase: FetchReservationUseCase,
        fetchReservationUserTypeUseCase: FetchReservationUserTypeUseCase,
        reservationId: String,
        reservationStatusFactory: ReservationStatusFactory
    ) {
        self.reservationCoordinator = reservationCoordinator
        self.fetchReservationUseCase = fetchReservationUseCase
        self.fetchReservationUserTypeUseCase = fetchReservationUserTypeUseCase
        self.reservationId = reservationId
        self.reservationStatusFactory = reservationStatusFactory
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.customerUserViewTap
            .compactMap { [weak self] _ in
                return self?.reservation?.customerUser
            }
            .bind(onNext: { [weak self] customerUser in
                self?.reservationCoordinator?.showCustomerReviewListViewController(customerUser: customerUser)
            })
            .disposed(by: disposeBag)
        
        input.photographerUserViewTap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                guard
                    let userId = owner.reservation?.photographerUser.userId,
                    let lat = owner.reservation?.latitude,
                    let lng = owner.reservation?.longitude
                else {
                    return
                }
                
                owner.reservationCoordinator?.connectDetailPhotographerFlow(
                    userId: userId,
                    searchCoordinate: Coordinate(lat: lat, lng: lng)
                )
            })
            .disposed(by: disposeBag)
        
        let fetchReservation = fetchReservationUseCase.execute(reservationId: reservationId)
        let reservationStatus = fetchReservation
            .withUnretained(self) { owner, reservation in
                owner.reservation = reservation
                return owner.reservationStatus(reservation: reservation)
            }
        
        let executePrimaryAction = input.primaryButtonTap
            .flatMap { reservationStatus }
            .flatMap { $0.executePrimaryAction() ?? .empty() }
            .withUnretained(self) { owner, reservation in
                return owner.reservationStatus(reservation: reservation)
            }
        
        let executeSecondaryAction = input.secondaryButtonTap
            .flatMap { reservationStatus }
            .flatMap { $0.executeSecondaryAction() ?? .empty() }
            .withUnretained(self) { owner, reservation in
                return owner.reservationStatus(reservation: reservation)
            }
        
        let reservationUpdated = Observable
            .of(reservationStatus, executePrimaryAction, executeSecondaryAction)
            .merge()
        
        return Output(
            reservation: fetchReservation,
            reservationStatus: reservationUpdated
        )
    }
}

// MARK: - Privates
private extension ReservationDetailViewModel {
    
    func reservationStatus(reservation: Reservation) -> ReservationStatus {
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
        guard let reservationStatusFactory else {
            return ReservationError()
        }
        
        switch reservation.status {
        case .request:
            return reservationStatusFactory.makeReservationRequested(reservation: reservation, userType: userType)
        case .confirm:
            return reservationStatusFactory.makeReservationConfirmed(reservation: reservation, userType: userType)
        case .cancel:
            return reservationStatusFactory.makeReservationCancelled(reservation: reservation, userType: userType)
        case .done:
            return reservationStatusFactory.makeReservationDone(reservation: reservation, userType: userType)
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

protocol ReservationStatusFactory: AnyObject {
    
    func makeReservationRequested(reservation: Reservation, userType: Reservation.UserType) -> ReservationRequested
    func makeReservationConfirmed(reservation: Reservation, userType: Reservation.UserType) -> ReservationConfirmed
    func makeReservationCancelled(reservation: Reservation, userType: Reservation.UserType) -> ReservationCancelled
    func makeReservationDone(reservation: Reservation, userType: Reservation.UserType) -> ReservationDone
}

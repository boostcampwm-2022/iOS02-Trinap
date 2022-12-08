//
//  LocationShareViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class LocationShareViewModel: ViewModelType {
    
    enum UserType {
        case mine, other
    }
    
    struct Input {
        var didTapTrackingMe: Signal<Void>
        var didTapTrackingOther: Signal<Void>
        var willChangeRegionWithScroll: Signal<Void>
        var myCoordinate: Observable<Coordinate>
    }
    
    struct Output {
        var userTypeBeingTracked: Observable<UserType?>
        var myCoordinate: Observable<Coordinate?>
        var otherCoordinate: Observable<Coordinate?>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private let chatroomId: String
    private let observeLocationUseCase: ObserveLocationUseCase
    private let updateLocationUseCase: UpdateLocationUseCase
    private let endLocationShareUseCase: EndLocationShareUseCase
    
    private let changeRegionSkipCount = 1
    
    // MARK: - Initializer
    init(
        chatroomId: String,
        observeLocationUseCase: ObserveLocationUseCase,
        updateLocationUseCase: UpdateLocationUseCase,
        endLocationShareUseCase: EndLocationShareUseCase
    ) {
        self.chatroomId = chatroomId
        self.observeLocationUseCase = observeLocationUseCase
        self.updateLocationUseCase = updateLocationUseCase
        self.endLocationShareUseCase = endLocationShareUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let coordinates = observeLocationUseCase.execute(chatroomId: chatroomId).share()
        let myCoordinate = coordinate(in: coordinates, ofUser: .mine)
        let otherCoordinate = coordinate(in: coordinates, ofUser: .other)
        
        updateMyCoordinate(input.myCoordinate)
        
        let userTypeBeingTracked = determineUserTypeBeingTracked(
            didTapTrackingMe: input.didTapTrackingMe,
            didTapTrackingOther: input.didTapTrackingOther,
            willChangeRegionWithScroll: input.willChangeRegionWithScroll.skip(changeRegionSkipCount)
        )
        
        return Output(
            userTypeBeingTracked: userTypeBeingTracked,
            myCoordinate: myCoordinate,
            otherCoordinate: otherCoordinate
        )
    }
    
    func endLocationShare() {
        endLocationShareUseCase.execute(chatroomId: chatroomId)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: - Privates
private extension LocationShareViewModel {
    
    func updateMyCoordinate(_ coordinate: Observable<Coordinate>) {
        coordinate
            .withUnretained(self)
            .flatMap { owner, coordinate in
                return owner.updateLocationUseCase.execute(chatroomId: owner.chatroomId, location: coordinate)
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func determineUserTypeBeingTracked(
        didTapTrackingMe: Signal<Void>,
        didTapTrackingOther: Signal<Void>,
        willChangeRegionWithScroll: Signal<Void>
    ) -> Observable<UserType?> {
        return Observable.of(
            didTapTrackingMe.map { return .mine },
            didTapTrackingOther.map { return .other },
            willChangeRegionWithScroll.map { return nil }
        )
        .merge()
        .distinctUntilChanged()
    }
    
    func coordinate(in coordinates: Observable<[SharedLocation]>, ofUser user: UserType) -> Observable<Coordinate?> {
        return coordinates.map { sharedLocation in
            guard let location = sharedLocation.first(where: { self.isLocation($0, of: user) }) else { return nil }
            
            return Coordinate(lat: location.latitude, lng: location.longitude)
        }
    }
    
    func isLocation(_ location: SharedLocation, of userType: UserType) -> Bool {
        if userType == .mine {
            return location.isMine
        } else {
            return !location.isMine
        }
    }
}

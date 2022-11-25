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
    
    struct Input {
        var didTapCurrentLocation: Signal<Void>
        var willChangeRegionWithScroll: Signal<Void>
        var myCoordinate: Observable<Coordinate>
    }
    
    struct Output {
        var isFollowCurrentLocation: Observable<Bool>
        var myCoordinate: Observable<Coordinate?>
        var otherCoordinate: Observable<Coordinate?>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private let chatroomId: String
    private let observeLocationUseCase: ObserveLocationUseCase
    private let updateLocationUseCase: UpdateLocationUseCase
    private var isFollowCurrentLocation = true
    
    #if targetEnvironment(simulator)
    let changeRegionSkipCount = 2
    #else
    let changeRegionSkipCount = 1
    #endif
    
    // MARK: - Initializer
    init(
        chatroomId: String,
        observeLocationUseCase: ObserveLocationUseCase,
        updateLocationUseCase: UpdateLocationUseCase
    ) {
        self.chatroomId = chatroomId
        self.observeLocationUseCase = observeLocationUseCase
        self.updateLocationUseCase = updateLocationUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let isFollowCurrentLocation = isFollowCurrentLocation(
            didTapCurrentLocation: input.didTapCurrentLocation,
            willChangeRegionWithScroll: input.willChangeRegionWithScroll
        )
        
        let coordinates = observeLocationUseCase.execute(chatroomId: chatroomId).share()
        let myCoordinate = coordinate(in: coordinates, ofUser: .mine)
        let otherCoordinate = coordinate(in: coordinates, ofUser: .other)
        
        input.myCoordinate
            .withUnretained(self)
            .flatMap { owner, coordinate in
                return owner.updateLocationUseCase.execute(chatroomId: owner.chatroomId, location: coordinate)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(
            isFollowCurrentLocation: isFollowCurrentLocation,
            myCoordinate: myCoordinate,
            otherCoordinate: otherCoordinate
        )
    }
}

// MARK: - Privates
private extension LocationShareViewModel {
    
    enum UserType {
        case mine, other
    }
    
    func isFollowCurrentLocation(
        didTapCurrentLocation: Signal<Void>,
        willChangeRegionWithScroll: Signal<Void>
    ) -> Observable<Bool> {
        let followingCurrentLocation = didTapCurrentLocation
            .map { [weak self] _ in
                return self?.followingCurrentLocation() ?? true
            }
        
        let unfollowingCurrentLocation = willChangeRegionWithScroll
            .skip(changeRegionSkipCount)
            .map { [weak self] _ in
                return self?.unfollowingCurrentLocation() ?? true
            }
        
        let followingSource = Observable.of(followingCurrentLocation, unfollowingCurrentLocation)
        
        return followingSource.merge().startWith(true)
    }
    
    func followingCurrentLocation() -> Bool {
        self.isFollowCurrentLocation = true
        return self.isFollowCurrentLocation
    }
    
    func unfollowingCurrentLocation() -> Bool {
        self.isFollowCurrentLocation = false
        return self.isFollowCurrentLocation
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

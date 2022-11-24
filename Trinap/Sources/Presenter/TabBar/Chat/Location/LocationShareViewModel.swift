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
    }
    
    struct Output {
        var isFollowCurrentLocation: Observable<Bool>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private var isFollowCurrentLocation = true
//    private let <#useCase#>: <#UseCaseType#>
    
    // MARK: - Initializer
//    init(<#parameters#>) {
//        <#statements#>
//    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let followingCurrentLocation = input.didTapCurrentLocation
            .map { [weak self] _ in
                return self?.followingCurrentLocation() ?? true
            }
        
        let unfollowingCurrentLocation = input.willChangeRegionWithScroll
            .skip(2)
            .map { [weak self] _ in
                return self?.unfollowingCurrentLocation() ?? true
            }
        
        let followingSource = Observable.of(followingCurrentLocation, unfollowingCurrentLocation)
        let isFollowCurrentLocation = followingSource.merge()
            .startWith(true)
        
        return Output(
            isFollowCurrentLocation: isFollowCurrentLocation
        )
    }
}

// MARK: - Privates
private extension LocationShareViewModel {
    
    func followingCurrentLocation() -> Bool {
        self.isFollowCurrentLocation = true
        return self.isFollowCurrentLocation
    }
    
    func unfollowingCurrentLocation() -> Bool {
        self.isFollowCurrentLocation = false
        return self.isFollowCurrentLocation
    }
}

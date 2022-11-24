//
//  DefaultObserveLocationUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

final class DefaultObserveLocationUseCase: ObserveLocationUseCase {
    
    // MARK: - Properties
    private let locationRepository: LocationRepository
    
    // MARK: - Initializers
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
    
    // MARK: - Methods
    func execute(chatroomId: String) -> Observable<SharedLocation> {
        return locationRepository.observe(chatroomId: chatroomId)
    }
}

//
//  DefaultFetchCurrentLocationUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchCurrentLocationUseCase: FetchCurrentLocationUseCase {
    
    // MARK: Properties
    private let mapRepository: MapRepository
    
    // MARK: Initializers
    init(mapRepository: MapRepository) {
        self.mapRepository = mapRepository
    }
    
    // MARK: Methods
    func fetchCurrentLocation() -> Observable<(Coordinate, String)> {
        let result = mapRepository.fetchCurrentLocation()
        var coor = Coordinate.seoulCoordinate
        
        if case let .success(success) = result {
            coor = success
        }
        
        return mapRepository.fetchLocationName(using: coor)
            .map { (coor, $0)}
    }

}

//
//  FakeMapRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

struct FakeMapRepository: MapRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    
    let results = BehaviorRelay<[Space]>(value: [])
    
    // MARK: - Initializers
    
    // MARK: - Methods
    func setSearchText(with searchText: String) {}
    
    func fetchCurrentLocation() -> Result<Coordinate, Error> {
        if isSucceedCase {
            return .success(.seoulCoordinate)
        } else {
            return .failure(FakeError.unknown)
        }
    }
    
    func fetchLocationName(using coordinate: Coordinate) -> Observable<String> {
        return execute(successValue: "Location Name")
    }
}

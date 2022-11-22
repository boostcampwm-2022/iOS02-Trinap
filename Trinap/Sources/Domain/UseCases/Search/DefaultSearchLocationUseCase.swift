//
//  DefaultSearchLocationUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit
import Foundation

import RxSwift
import RxRelay

final class DefaultSearchLocationUseCase: SearchLocationUseCase {
    
    // MARK: Properties
    private let mapService: MapRepository
    
    // MARK: Initializers
    init(mapService: MapRepository) {
        self.mapService = mapService
    }
    
    // MARK: Methods
    func fetchSearchList(with searchText: String) -> Observable<[Space]> {
        mapService.setSearchText(with: searchText)
        return mapService.results.asObservable()
    }
}

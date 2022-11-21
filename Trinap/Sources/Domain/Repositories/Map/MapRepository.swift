//
//  MapRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit
import Foundation

import RxSwift
import RxRelay

protocol MapRepository {
    // MARK: Properties
    var results: BehaviorRelay<[Space]> { get }
    
    // MARK: Methods
    func setSearchText(with searchText: String)
    func fetchCurrentLocation() -> Observable<Coordinate>
}

//
//  FetchCurrentLocation.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchCurrentLocationUseCase {
    
    // MARK: Methods
    func fetchCurrentLocation() -> Observable<(Coordinate, String)>
}

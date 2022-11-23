//
//  FetchPhotographersUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchPhotographersUseCase {
    
    // MARK: Methods
    func fetch(type: TagType) -> Observable<[PhotographerPreview]>
    func fetch(coordinate: Coordinate) -> Observable<[PhotographerPreview]>
}

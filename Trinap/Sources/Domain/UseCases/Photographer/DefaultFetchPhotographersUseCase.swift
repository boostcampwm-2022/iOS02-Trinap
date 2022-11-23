//
//  DefaultFetchPhotographersUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchPhotographersUseCase: FetchPhotographersUseCase {
    
    // MARK: Properties
    private let photographerRepository: PhotographerRepository

    // MARK: Initializers
    init(
        photographerRepository: PhotographerRepository
    ) {
        self.photographerRepository = photographerRepository
    }
    
    // MARK: Methods
    func fetch(type: TagType) -> Observable<[Photographer]> {
        return photographerRepository
            .fetchPhotographers(type: type)
    }
    
    func fetch(coordinate: Coordinate) -> Observable<[Photographer]> {
        return photographerRepository
            .fetchPhotographers(coordinate: coordinate)
    }

}

//
//  DefaultFetchPhotographerUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchPhotographerUseCase: FetchPhotographerUseCase {
    
    // MARK: Properties
    private let photographerRespository: PhotographerRepository
    
    // MARK: Initializer
    init(photographerRespository: PhotographerRepository) {
        self.photographerRespository = photographerRespository
    }
    
    // MARK: Methods
    func fetch(photographerUserId: String) -> Observable<Photographer> {
        return photographerRespository.fetchDetailPhotographer(userId: photographerUserId)
    }
}

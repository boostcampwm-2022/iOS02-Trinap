//
//  DefaultEditPhotographerUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultEditPhotographerUseCase: EditPhotographerUseCase {
    
    // MARK: Properties
    private let photographerRepository: PhotographerRepository
    
    init(photographerRepository: PhotographerRepository) {
        self.photographerRepository = photographerRepository
    }
    
    // MARK: Methods
    func updatePhotographer(photographer: Photographer) -> Observable<Void> {
        return photographerRepository.updatePhotograhperInformation(with: photographer)
    }
    
    func createPhotographer(
        coordinate: Coordinate,
        introduction: String,
        tags: [TagType],
        pricePerHalfHour: Int
    ) -> Observable<Void> {
        let photographer = Photographer(
            photographerId: UUID().uuidString,
            photographerUserId: "",
            introduction: introduction,
            latitude: coordinate.lat,
            longitude: coordinate.lng,
            tags: tags,
            pictures: [],
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: []
        )
        return photographerRepository.create(photographer: photographer)
    }
}

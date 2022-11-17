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
        location: String,
        introduction: String,
        tags: [TagType],
        pricePerHalfHour: Int
    ) -> Observable<Void> {
        //TODO: 현재 photographerUserId를 repository에서 넣어줘야해서 빈 값으로 넘기고 repository에서 값을 넣어준느데 수정할 방안이 있을지?
        let photographer = Photographer(
            photographerId: UUID().uuidString,
            photographerUserId: "",
            location: location,
            introduction: introduction,
            tags: tags,
            pictures: [],
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: []
        )
        return photographerRepository.create(photographer: photographer)
    }
}

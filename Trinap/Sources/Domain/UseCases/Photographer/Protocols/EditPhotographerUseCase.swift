//
//  EditPhotographerUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol EditPhotographerUseCase {
    
    // MARK: Methods
    func updatePhotographer(photographer: Photographer) -> Observable<Void>
    func createPhotographer(
        location: String,
        introduction: String,
        tags: [TagType],
        pricePerHalfHour: Int
    ) -> Observable<Void>
}

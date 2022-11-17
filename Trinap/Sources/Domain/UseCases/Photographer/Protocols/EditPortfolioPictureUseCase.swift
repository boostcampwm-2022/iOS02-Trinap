//
//  EditPortfolioPictureUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol EditPortfolioPictureUseCase {
    
    // MARK: Methods
    func delete(photographer: Photographer, indices: [Int]) -> Observable<Void>
    func add(
        photographerId: String,
        currentPictures: [String],
        pictureData: Data
    ) -> Observable<Void>
}

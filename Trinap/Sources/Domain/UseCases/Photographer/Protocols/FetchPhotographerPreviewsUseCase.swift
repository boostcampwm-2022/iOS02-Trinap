//
//  FetchPhotographerPreviewsUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchPhotographerPreviewsUseCase {
    
    // MARK: Methods
    func fetch(coordinate: Coordinate?, type: TagType) -> Observable<[PhotographerPreview]>
}

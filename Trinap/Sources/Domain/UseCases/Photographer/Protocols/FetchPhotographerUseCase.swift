//
//  FetchPhotographerUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchPhotographerUseCase {
    
    // MARK: Methods
    func fetch(photographerUserId: String) -> Observable<Photographer>
}

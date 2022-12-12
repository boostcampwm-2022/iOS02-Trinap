//
//  FetchPhotographerUserUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchPhotographerUserUseCase {
    func fetch(userId: String) -> Observable<PhotographerUser>
}

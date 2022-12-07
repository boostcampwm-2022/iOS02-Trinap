//
//  CreateChatroomUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateChatroomUseCase {

    // MARK: Methods
    func create(photographerUserId: String) -> Observable<String>
}

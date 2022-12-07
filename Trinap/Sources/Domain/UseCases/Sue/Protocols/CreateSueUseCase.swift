//
//  CreateSueUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateSueUseCase {

    // MARK: Methods
    func create(suedUserId: String, contents: Sue.SueContents) -> Observable<Void>
}

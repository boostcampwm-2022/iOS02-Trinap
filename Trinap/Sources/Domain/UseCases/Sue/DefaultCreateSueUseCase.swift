//
//  DefaultCreateSueUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultCreateSueUseCase: CreateSueUseCase {

    // MARK: Properties
    private let sueRepository: SueRepository
    
    // MARK: Initializers
    init(sueRepository: SueRepository) {
        self.sueRepository = sueRepository
    }
    
    // MARK: Methods
    func create(suedUserId: String, contents: Sue.SueContents) -> Observable<Void> {
        return sueRepository.sueUser(suedUserId: suedUserId, contents: contents.contents)
            .asObservable()
    }
}

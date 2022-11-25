//
//  DefaultEndLocationShareUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

final class DefaultEndLocationShareUseCase: EndLocationShareUseCase {
    
    // MARK: - Properties
    private let locationRepository: LocationRepository
    
    // MARK: - Initializers
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
    
    // MARK: - Methods
    func execute(chatroomId: String) -> Observable<Void> {
        return locationRepository.endShare(chatroomId: chatroomId)
    }
}

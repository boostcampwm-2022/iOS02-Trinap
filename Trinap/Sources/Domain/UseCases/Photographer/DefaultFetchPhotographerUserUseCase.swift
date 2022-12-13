//
//  DefaultFetchPhotographerUserUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchPhotographerUserUseCase: FetchPhotographerUserUseCase {
        
    // MARK: Properties
    private let userRepository: UserRepository
    private let photographerRepository: PhotographerRepository
    private let mapRepository: MapRepository
    
    // MARK: Initializers
    init(
        userRepository: UserRepository,
        photographerRepository: PhotographerRepository,
        mapRepository: MapRepository
    ) {
        self.userRepository = userRepository
        self.photographerRepository = photographerRepository
        self.mapRepository = mapRepository
    }
    
    // MARK: Methods
    func fetch(userId: String) -> Observable<PhotographerUser> {
        userRepository.fetch(userId: userId)
            .withUnretained(self)
            .flatMap { owner, user in
                owner.photographerRepository.fetchDetailPhotographer(userId: user.userId)
                    .flatMap { photographer in
                        return owner.mapRepository.fetchLocationName(
                            using: Coordinate(lat: photographer.latitude,lng: photographer.longitude)
                        )
                        .map { location in
                            PhotographerUser(user: user, photographer: photographer, location: location)
                        }
                    }
            }
    }

}

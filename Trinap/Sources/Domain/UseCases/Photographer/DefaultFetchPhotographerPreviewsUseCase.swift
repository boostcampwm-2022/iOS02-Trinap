//
//  DefaultFetchPhotographerPreviewsUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchPhotographerPreviewsUseCase: FetchPhotographerPreviewsUseCase {
    
    // MARK: Properties
    private let photographerRepository: PhotographerRepository
    private let mapRepository: MapRepository
    private let userRepository: UserRepository
    private let reviewRepository: ReviewRepository
    private let disposebag = DisposeBag()
    
    // MARK: Initializers
    init(
        photographerRepository: PhotographerRepository,
        mapRepository: MapRepository,
        userRepository: UserRepository,
        reviewRepository: ReviewRepository
    ) {
        self.photographerRepository = photographerRepository
        self.mapRepository = mapRepository
        self.userRepository = userRepository
        self.reviewRepository = reviewRepository
    }
    
    // MARK: Methods
    func fetch(type: TagType) -> Observable<[PhotographerPreview]> {
        return photographerRepository
            .fetchPhotographers(type: type)
            .withUnretained(self)
            .flatMap { owner, photographers in
                Observable.zip(
                    photographers.map { photographer in
                        owner.convertPreview(photographer: photographer)
                    }
                )
            }
    }
    
    func fetch(coordinate: Coordinate) -> Observable<[PhotographerPreview]> {
        return photographerRepository
            .fetchPhotographers(coordinate: coordinate)
            .withUnretained(self)
            .flatMap { owner, photographers in
                Observable.zip(
                    photographers.map { photographer in
                        owner.convertPreview(photographer: photographer)
                    }
                )
            }
    }
    
    private func convertPreview(photographer: Photographer) -> Observable<PhotographerPreview> {
        let coor = Coordinate(
            lat: photographer.latitude,
            lng: photographer.longitude
        )
        let name = mapRepository.fetchLocationName(using: coor)
        let user = userRepository.fetch(userId: photographer.photographerUserId)
        let rating = fetchAverageReview(photographerId: photographer.photographerUserId)

        return Observable.zip(name, user, rating)
            .filter { location, user, rating in
                return user.isPhotographer
            }
            .map{ location, user, rating in
                Logger.print(rating)
                return PhotographerPreview(
                    photographer: photographer,
                    location: location,
                    name: user.nickname,
                    rating: rating
                )
            }
    }
    
    private func matchCoordinate(coordinate: Coordinate?) -> Coordinate {
        if let coordinate { return coordinate }
        let coordinate = mapRepository.fetchCurrentLocation()
        switch coordinate {
        case .success(let coor):
            return coor
        case .failure(_):
            return Coordinate(lat: 37.5642135, lng: 127.269311)
        }
    }
    
    private func fetchAverageReview(photographerId: String) -> Observable<Double> {
        return reviewRepository.fetchReviews(id: photographerId, target: .photographer)
            .map {
                let reviewRatings = $0.map { $0.rating }
                let averageRating = Double(reviewRatings.reduce(0, +)) / Double(reviewRatings.count)
                
                if averageRating.isNaN { return 0 }
                
                return round(averageRating * 10) / 10
            }
            .asObservable()
    }
}

//
//  ReviewRepository.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultReviewRepository: ReviewRepository {
    
    // MARK: - Properties
    private let fireStoreService: FireStoreService
    private let keychainManager: TokenManager
    
    init(keychainManager: TokenManager) {
        self.fireStoreService = DefaultFireStoreService()
        self.keychainManager = KeychainTokenManager()
    }
    
    // MARK: - Methods
    func fetchReviews(id: String, target: ReviewTarget) -> Observable<[Review]> {
        return fireStoreService.getDocument(collection: .reviews, field: target.rawValue, in: [id])
            .map { $0.compactMap { $0.toObject(ReviewDTO.self)?.toModel() } }
            .asObservable()
    }
    
    func createReview(to photograhper: String, review: Review) -> Observable<Bool> {
        guard let token = keychainManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        let dto = ReviewDTO(
            creatorUserId: token,
            photographerUserId: photograhper,
            reviewId: review.reviewId,
            contents: review.contents,
            status: review.status,
            rating: review.rating
        )
        
        guard let values = dto.asDictionary else {
            return .just(false)
        }
        
        return fireStoreService.createDocument(collection: .reviews, document: review.reviewId, values: values)
            .map { true }
            .catchAndReturn(false)
            .asObservable()
    }
}

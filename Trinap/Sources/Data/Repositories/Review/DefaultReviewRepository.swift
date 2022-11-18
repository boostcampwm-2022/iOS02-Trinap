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
    
    func createReview(to photograhperId: String, contents: String, rating: Int) -> Observable<Bool> {
        guard let token = keychainManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }
        
        let reviewId = UUID().uuidString
        
        let dto = ReviewDTO(
            creatorUserId: token,
            photographerUserId: photograhperId,
            reviewId: reviewId,
            contents: contents,
            status: "activate",
            rating: rating
        )
        
        guard let values = dto.asDictionary else {
            return .just(false)
        }
        
        return fireStoreService.createDocument(collection: .reviews, document: reviewId, values: values)
            .map { true }
            .catchAndReturn(false)
            .asObservable()
    }
}

//
//  MockReviewRepository.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

@testable import Trinap

enum MockFireStoreError: Error {
    case invalidUser
}

final class MockReviewRepository: ReviewRepository {
    
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    
    func fetchReviews(id: String, target: ReviewTarget) -> Observable<[Review]> {
        
        if id.isEmpty {
            return .error(MockFireStoreError.invalidUser)
        }
        
        let review = Review(
            reviewId: "16D37C9D-EF25-4977-94B4-F65A5E7127A4",
            photographerUserId: id,
            creatorUserId: "d7MTE9ZYLNg6JQOK4dQ0",
            contents: "리뷰리뷰",
            status: "activate",
            createdAt: Date(),
            rating: 4
        )
        
        return .just([review])
    }
    
    func fetchReview(target: ReviewTarget) -> Observable<[Review]> {
        
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let review = Review(
            reviewId: "16D37C9D-EF25-4977-94B4-F65A5E7127A4",
            photographerUserId: userId,
            creatorUserId: "d7MTE9ZYLNg6JQOK4dQ0",
            contents: "리뷰리뷰",
            status: "activate",
            createdAt: Date(),
            rating: 4
        )
        return .just([review])
    }
    
    func createReview(to photograhperId: String, contents: String, rating: Int) -> Observable<Bool> {
        return .just(!(contents.isEmpty || rating <= 0 || rating > 5))
    }
}

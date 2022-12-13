//
//  FakeReviewRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct FakeReviewRepository: ReviewRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    
    // MARK: - Initializers
    init(isSucceedCase: Bool = FakeRepositoryEnvironment.isSucceedCase) {
        self.isSucceedCase = isSucceedCase
    }
    
    // MARK: - Methods
    func fetchReviews(id: String, target: ReviewTarget) -> Observable<[Review]> {
        var reviews: [Review] = []
        
        for i in 1...Int.random(in: 20...40) {
            reviews.append(.stub(reviewId: "reviewId\(i)"))
        }
        
        return execute(successValue: reviews)
    }
    
    func fetchReview(target: ReviewTarget) -> Observable<[Review]> {
        var reviews: [Review] = []
        
        for i in 1...Int.random(in: 20...40) {
            reviews.append(.stub(reviewId: "reviewId\(i)"))
        }
        
        return execute(successValue: reviews)
    }
    
    func createReview(to photograhperId: String, contents: String, rating: Int) -> Observable<Bool> {
        return execute(successValue: isSucceedCase)
    }
}

extension Review {
    
    static func stub(
        reviewId: String = UUID().uuidString,
        photographerUserId: String = "userId1",
        creatorUserId: String = "userId2",
        contents: String = .random,
        status: String = "activate",
        createdAt: Date = Date(),
        rating: Int = .random(in: 1...5)
    ) -> Review {
        return Review(
            reviewId: UUID().uuidString,
            photographerUserId: photographerUserId,
            creatorUserId: creatorUserId,
            contents: contents,
            status: status,
            createdAt: createdAt,
            rating: rating
        )
    }
}

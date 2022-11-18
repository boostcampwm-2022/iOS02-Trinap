//
//  DefaultCreateReviewUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultCreateReviewUseCase: CreateReviewUseCase {
    
    private let reviewRepository: ReviewRepository
    
    init(reviewRepository: ReviewRepository) {
        self.reviewRepository = reviewRepository
    }
    
    func createReview(photographerId: String, contents: String, rating: Int) -> Observable<Bool> {
        return reviewRepository.createReview(to: photographerId, contents: contents, rating: rating)
            .asObservable()
    }
}

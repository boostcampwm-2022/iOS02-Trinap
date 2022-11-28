//
//  FetchReviewUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchReviewUseCase {
    func fetchAverageReview(photographerId: String?) -> Observable<ReviewSummary>
//    func fetchReviews(userId: String) -> Observable<[UserReview]>
    func fetchReviews(photographerUserId: String?) -> Observable<[UserReview]>
}

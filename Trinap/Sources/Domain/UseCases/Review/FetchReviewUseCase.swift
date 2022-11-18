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
    
    /// PhotograhperID 넘기거나 UserID..
    func fetchAverageReview(photograhperId: String) -> Observable<Int>
    func fetchReviews(userId: String) -> Observable<[Review]>
    func fetchReviews(photograhperId: String) -> Observable<[Review]>
}

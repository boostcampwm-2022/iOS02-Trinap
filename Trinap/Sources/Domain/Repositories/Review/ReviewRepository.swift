//
//  ReviewRepository.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol ReviewRepository {
    
    // MARK: - Methods
    func fetchReviews(id: String, target: ReviewTarget) -> Observable<[Review]>
    func fetchReview(target: ReviewTarget) -> Observable<[Review]>
    func createReview(to photograhperId: String, contents: String, rating: Int) -> Observable<Bool>
}

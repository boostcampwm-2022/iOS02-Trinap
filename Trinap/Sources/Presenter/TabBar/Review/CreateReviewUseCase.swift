//
//  CreateReviewUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol CreateReviewUseCase {
    func createReview(photographerId: String, contents: String, rating: Int) -> Observable<Bool>
    func checkButtonEnabled(text: String, rating: Int) -> Bool
}

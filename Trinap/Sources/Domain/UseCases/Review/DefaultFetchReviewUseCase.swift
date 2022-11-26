//
//  DefaultReviewUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchReviewUseCase: FetchReviewUseCase {
    
    // MARK: - Properties
    private let reviewRepository: ReviewRepository
    private let userRepository: UserRepository
    private let photographerRepository: PhotographerRepository
    
    init(
        reviewRepositry: ReviewRepository,
        userRepository: UserRepository,
        photographerRepository: PhotographerRepository
    ) {
        self.reviewRepository = reviewRepositry
        self.userRepository = userRepository
        self.photographerRepository = photographerRepository
    }
    
    // MARK: - Methods
    /// 리뷰 평균 별점
    func fetchAverageReview(photographerId: String) -> Observable<ReviewSummary> {
        return reviewRepository.fetchReviews(id: photographerId, target: .photographer)
            .map {
                let reviewRatings = $0.map { $0.rating }
                let averageRating = Double(reviewRatings.reduce(0, +)) / Double(reviewRatings.count)
                
                return ReviewSummary(rating: round(averageRating * 10) / 10, count: reviewRatings.count)
            }
            .asObservable()
    }
    
    /// 유저가 작성한 리뷰 확인
    func fetchReviews(userId: String) -> Observable<[UserReview]> {
        return reviewRepository.fetchReviews(id: userId, target: .customer)
            .withUnretained(self)
            .flatMap { owner, reviews in
                return owner.mappingReviewWithUser(reviews: reviews)
            }
    }
    
    /// 작가에게 작성된 리뷰 확인
    func fetchReviews(photographerId: String) -> Observable<[PhotographerReview]> {
        Logger.print(photographerId)
        return reviewRepository.fetchReviews(id: photographerId, target: .photographer)
            .flatMap { reviews in
                return self.mappingReviewOfPhotographer(reviews: reviews)
            }
    }
}

extension DefaultFetchReviewUseCase {

    private func mappingReviewWithUser(reviews: [Review]) -> Observable<[UserReview]> {
        
        /// 중복된 id제거
        let photographerIds = reviews.map { $0.photographerUserId }.removingDuplicates()
        
        return photographerIds.isEmpty ? .just([]) : photographerRepository.fetchPhotographers(ids: photographerIds)
            .map { photographers in
                var userReviews: [UserReview] = []
                
                for photographer in photographers {
                    print(photographer)
                    for review in reviews where review.photographerUserId == photographer.photographerUserId {
                        
                        let userReview = UserReview(
                            photorgrapher: photographer,
                            contents: review.contents,
                            rating: review.rating
                        )
                        userReviews.append(userReview)
                    }
                }
                
                return userReviews
            }
    }
    
    private func mappingReviewOfPhotographer(reviews: [Review]) -> Observable<[PhotographerReview]> {
        
        print(reviews)
        /// 중복된 id제거
        let userIds = reviews.map { $0.creatorUserId }.removingDuplicates()
        
        return userIds.isEmpty ? .just([]) : userRepository.fetchUsers(userIds: userIds)
            .map { users in
                
                var photographerReviews: [PhotographerReview] = []
                
                for user in users {
                    for review in reviews where review.creatorUserId == user.userId {
                        let photographerReview = PhotographerReview(
                            user: user,
                            contents: review.contents,
                            rating: review.rating)
                        
                        photographerReviews.append(photographerReview)
                    }
                }
                
                return photographerReviews
            }
    }
}

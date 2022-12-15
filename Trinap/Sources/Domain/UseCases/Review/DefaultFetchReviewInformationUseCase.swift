//
//  DefaultFetchReviewInformationUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchReviewInformationUseCase: FetchReviewInformationUseCase {

    // MARK: Properties
    private let reviewRepository: ReviewRepository
    private let userRepository: UserRepository
    
    // MARK: Initializers
    init(
        reviewRepository: ReviewRepository,
        userRepository: UserRepository
    ) {
        self.reviewRepository = reviewRepository
        self.userRepository = userRepository
    }
    
    // MARK: Methods
    func fetch(photographerUserId: String) -> Observable<ReviewInformation> {
        let summary = self.fetchAverageReview(photographerUserId: photographerUserId)
        let reviews = self.fetchReviews(photographerUserId: photographerUserId)
        
        return Observable.zip(summary, reviews)
            .map { summary, reviews in
                guard !summary.rating.isNaN
                else {
                    return ReviewInformation(
                        summary: ReviewSummary(rating: 0.0, count: summary.count),
                        reviews: reviews
                    )
                }
                return ReviewInformation(summary: summary, reviews: reviews)
            }
    }
    
    func fetchAverageReview(photographerUserId: String?) -> Observable<ReviewSummary> {
        guard let photographerUserId else {
            return reviewRepository.fetchReview(target: .photographer)
                .withUnretained(self)
                .map { owner, reviews in
                    owner.mappingReviewSummary(reviews)
                }
                .asObservable()
        }
        return reviewRepository.fetchReviews(id: photographerUserId, target: .photographer)
            .withUnretained(self)
            .map { owner, reviews in
                owner.mappingReviewSummary(reviews)
            }
            .asObservable()
    }
    
    func fetchReviews(photographerUserId: String?) -> Observable<[UserReview]> {
        guard let photographerUserId else {
            return reviewRepository.fetchReview(target: .photographer)
                .flatMap { reviews in
                    return self.mappingReviewOfPhotographer(reviews: reviews)
                }
        }
        
        return reviewRepository.fetchReviews(id: photographerUserId, target: .photographer)
            .flatMap { reviews in
                return self.mappingReviewOfPhotographer(reviews: reviews)
            }
    }
}

extension DefaultFetchReviewInformationUseCase {

    private func mappingReviewWithUser(reviews: [Review]) -> Observable<[UserReview]> {
        let userIds = reviews.map { $0.creatorUserId }.removingDuplicates()
        
        return userRepository.fetchUsersWithMine(userIds: userIds)
            .withUnretained(self) { owner, users in
                return owner.configureUserReview(reviews: reviews, users: users)
            }
    }
    
    private func mappingReviewOfPhotographer(reviews: [Review]) -> Observable<[UserReview]> {
        let userIds = reviews.map { $0.creatorUserId }.removingDuplicates()
        
        return userIds.isEmpty ? .just([]) : userRepository.fetchUsersWithMine(userIds: userIds)
            .withUnretained(self) { owner, users in
                return owner.configureUserReview(reviews: reviews, users: users)
            }
    }
    
    private func configureUserReview(reviews: [Review], users: [User]) -> [UserReview] {
        var userReviews: [UserReview] = []
        
        for user in users {
            for review in reviews where review.creatorUserId == user.userId {
                let userReview = UserReview(
                    user: user,
                    contents: review.contents,
                    rating: review.rating,
                    createdAt: review.createdAt
                )
                
                userReviews.append(userReview)
            }
        }
        
        return userReviews
    }
    
    private func mappingReviewSummary(_ reivew: [Review]) -> ReviewSummary {
        let reviewRatings = reivew.map { $0.rating }
        let averageRating = Double(reviewRatings.reduce(0, +)) / Double(reviewRatings.count)
        
        return ReviewSummary(rating: round(averageRating * 10) / 10, count: reviewRatings.count)
    }
}

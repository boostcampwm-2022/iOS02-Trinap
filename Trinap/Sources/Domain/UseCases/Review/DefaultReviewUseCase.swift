//
//  DefaultReviewUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultFetchReviewUseCase {
    
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
    func fetchAverageReview(photograhperId: String) -> Observable<Double> {
        return reviewRepository.fetchReviews(id: photograhperId, target: .photographer)
            .map {
                let reviewRatings = $0.map { $0.rating }
                return Double(reviewRatings.reduce(0, +)) / Double(reviewRatings.count)
            }
            .asObservable()
    }
    
    /// 유저가 작성한 리뷰 확인
    func fetchReviews(userId: String) -> Observable<[UserReview]> {
        return reviewRepository.fetchReviews(id: userId, target: .customer)
            .withUnretained(self)
            .flatMap { owner, reviews in
                return owner.convertToUserReview(reviews: reviews)
            }
    }
    
    /// 작가에게 작성된 리뷰 확인
    func fetchReviews(photographerId: String) -> Observable<[PhotographerReview]> {
        return reviewRepository.fetchReviews(id: photographerId, target: .photographer)
            .withUnretained(self)
            .flatMap { owner, reviews in
                return owner.convertToPhotographerReview(reviews: reviews)
            }
    }
}

extension DefaultFetchReviewUseCase {
    
    private func convertToUserReview(reviews: [Review]) -> Observable<[UserReview]> {
        let photographerIds = reviews.map { $0.photographerId }
        
        return photographerRepository.fetchPhotographers(ids: photographerIds)
            .map { photographers in
                
                var userReviews: [UserReview] = []
                
                for photographer in photographers {
                    for review in reviews where review.photographerId == photographer.photographerUserId {
                        
                        let userReview = UserReview(
                            photorgrapher: photographer,
                            contents: review.contents,
                            rating: review.rating
                        )
                        userReviews.append(userReview)
                        break
                    }
                }
                
                return userReviews
            }
    }
    
    private func convertToPhotographerReview(reviews: [Review]) -> Observable<[PhotographerReview]> {
        
        let userIds = reviews.map { $0.creatorId }
        
        return userRepository.fetchUsers(userIds: userIds)
            .map { users in
                
                var photographerReviews: [PhotographerReview] = []
                
                for user in users {
                    for review in reviews where review.creatorId == user.userId {
                        let photographerReview = PhotographerReview(
                            user: user,
                            contents: review.contents,
                            rating: review.rating)
                        
                        photographerReviews.append(photographerReview)
                        break
                    }
                }
                
                return photographerReviews
            }
    }
}

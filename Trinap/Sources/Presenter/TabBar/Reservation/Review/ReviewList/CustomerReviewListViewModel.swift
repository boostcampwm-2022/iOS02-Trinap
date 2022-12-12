//
//  CustomerReviewListViewModel.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class CustomerReviewListViewModel: ViewModelType {
    
    struct Input {}
    
    struct Output {
        var reviewList: Observable<[UserReview]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var userNickname: String { return creatorUser.nickname }
    
    private let fetchReviewUseCase: FetchReviewUseCase
    private let creatorUser: User
    private weak var reservationCoordinator: Coordinator?
    
    // MARK: - Initializer
    init(
        fetchReviewUseCase: FetchReviewUseCase,
        creatorUser: User,
        reservationCoordinator: Coordinator?
    ) {
        self.fetchReviewUseCase = fetchReviewUseCase
        self.creatorUser = creatorUser
        self.reservationCoordinator = reservationCoordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let reviewList = fetchReviewUseCase.fetchReviews(userId: creatorUser.userId)
        
        return Output(reviewList: reviewList)
    }
}

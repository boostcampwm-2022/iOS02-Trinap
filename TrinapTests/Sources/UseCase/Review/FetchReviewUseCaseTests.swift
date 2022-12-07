//
//  FetchReviewUseCaseTests.swift
//  TrinapTests
//
//  Created by Doyun Park on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import XCTest

import RxBlocking
import RxSwift
import RxTest

@testable import Trinap

final class FetchReviewUseCaseTests: XCTestCase {
    
    // MARK: - Properteis
    private var fetchReviewUseCase: FetchReviewUseCase!
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        self.fetchReviewUseCase = DefaultFetchReviewUseCase(
            reviewRepositry: MockReviewRepository(tokenManager: KeychainTokenManager()),
            userRepository: MockUserRepository(),
            photographerRepository: DefaultPhotographerRepository()
        )
        
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        self.fetchReviewUseCase = nil
        self.scheduler = nil
        self.disposeBag = nil
        
        try super.tearDownWithError()
    }
    
    func test_fetch_reviews() {
        
        let reviews = scheduler.createObserver(Bool.self)
        
        self.scheduler
            .createHotObservable([
                .next(210, ""),
                .next(300, "363B9925-06AC-495E-9DE4-41D34F72BBEE")
            ])
            .withUnretained(self)
            .flatMap { onwer, id in
                return onwer.fetchReviewUseCase.fetchReviews(photographerUserId: id)
                    .map { _ in true }
                    .catchAndReturn(false)
            }
            .bind(to: reviews)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(reviews.events, [
            .next(210, false),
            .next(300, true)
        ])
    }
}

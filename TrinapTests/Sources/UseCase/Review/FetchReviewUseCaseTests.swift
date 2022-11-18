//
//  FetchReviewUseCaseTests.swift
//  TrinapTests
//
//  Created by Doyun Park on 2022/11/18.
//  Copyright © 2022 Trinap. All rights reserved.
//

import XCTest

import RxSwift
import RxTest

@testable import Trinap

final class FetchReviewUseCaseTests: XCTestCase {
    
    private var fetchReviewUseCase: FetchReviewUseCase!
    
    private var scheduler: TestScheduler!
    private var disposBag: DisposeBag!
    
    override func setUpWithError() throws {
        self.fetchReviewUseCase = DefaultFetchReviewUseCase(
            reviewRepositry: MockReviewRepository(),
            userRepository: MockUserRepository(),
            photographerRepository: DefaultPhotographerRepository()
        )
        
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.fetchReviewUseCase = nil
        self.scheduler = nil
        self.disposBag = nil
        
        try super.tearDownWithError()
    }
    
    func test_fetch_reviews() {
        let reviews = scheduler.createObserver(Bool.self)
        
        let resultObseravble = self.scheduler
            .createColdObservable([
                .next(10, ""),
                .next(20, "363B9925-06AC-495E-9DE4-41D34F72BBEE")
            ])
            .flatMap {
                return self.fetchReviewUseCase.fetchReviews(photographerId: $0).map { _ in true }.catchAndReturn(false)
            }
            .bind(to: reviews)
        
        self.scheduler.start()
        
        XCTAssertEqual(reviews.events, [
            .next(10, false),
            .next(20, true)
        ])
    }
}

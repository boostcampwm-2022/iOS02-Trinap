//
//  CreateReviewViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class CreateReviewViewModel: ViewModelType {
    
    // MARK: - Properties
    private let createReviewUseCase: CreateReviewUseCase
    private let photographerId: String
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let rating: Observable<Int>
        let contents: Observable<String>
        let textViewEndEditing: Observable<Void>
        let trigger: Observable<Void>
    }
    
    struct Output {
        let buttonEnabled: Observable<Bool>
        let result: Observable<Bool>
    }

    // MARK: - Initializer
    init(
        photographerId: String,
        createReviewUseCase: CreateReviewUseCase
    ) {
        self.photographerId = photographerId
        self.createReviewUseCase = createReviewUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        let parameters = Observable.combineLatest(
            input.textViewEndEditing.withLatestFrom(input.contents),
            input.rating
        )

        let result = input.trigger
            .withLatestFrom(parameters)
            .withUnretained(self)
            .flatMap { owner, element in
                let (review, rating) = element
                return owner.createReviewUseCase.createReview(
                    photographerId: owner.photographerId,
                    contents: review,
                    rating: rating
                )
            }

        let buttonEnabled = Observable
            .combineLatest(input.contents, input.rating)
            .withUnretained(self)
            .map { owner, element in
                let (contents, rating) = element
                return owner.createReviewUseCase.checkButtonEnabled(text: contents, rating: rating)
            }
        
        return Output(buttonEnabled: buttonEnabled, result: result)
    }
}

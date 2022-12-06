//
//  CreateContactViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class CreateContactViewModel: ViewModelType {
    
    struct Input {
        let title: Observable<String>
        let contents: Observable<String>
        let buttonTrigger: Observable<Void>
    }
    
    struct Output {
        let isValid: Observable<Bool>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private let createContactUseCase: CreateContactUseCase
    private weak var coordinator: MyPageCoordinator?
    
    let placeholder = "문의 사항을 입력해주세요"
    
    // MARK: - Initializer
    init(
        coordinator: MyPageCoordinator?,
        createContactUseCase: CreateContactUseCase
    ) {
        self.coordinator = coordinator
        self.createContactUseCase = createContactUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        let parameter = Observable.combineLatest(input.title, input.contents)
            .share()
        
        let isValid = parameter
            .map { title, contents in
                false == title.isEmpty && false == contents.isEmpty
            }
        
        input.buttonTrigger
            .withLatestFrom(parameter)
            .flatMap { title, contents in
                self.createContactUseCase.create(title: title, contents: contents)
            }
            .subscribe { [weak self] _ in
                self?.coordinator?.dismissViewController()
            }
            .disposed(by: disposeBag)

        return Output(isValid: isValid)
    }
}

//
//  SueViewModel.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class SueViewModel: ViewModelType {

    struct Input {
        let sueContents: Observable<Sue.SueContents>
        let confirmTrigger: Observable<Void>
    }

    struct Output {
        let userName: Driver<String>
        let isValid: Driver<Bool>
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()

    private let userId: String
    private weak var coordinator: PhotographerDetailCoordinator?
    
    let placeholder = "사유를 입력해주세요"

    private let createSueUseCase: CreateSueUseCase
    private let fetchUserUseCase: FetchUserUseCase

    // MARK: - Initializer
    init(
        userId: String,
        createSueUseCase: CreateSueUseCase,
        fetchUserUseCase: FetchUserUseCase,
        coordinator: PhotographerDetailCoordinator?
    ) {
        self.userId = userId
        self.createSueUseCase = createSueUseCase
        self.fetchUserUseCase = fetchUserUseCase
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {

        let suedUser = fetchUserUseCase
            .fetchUserInfo(userId: userId)
            .share()
        
        let userName = suedUser
            .map { $0.nickname }
            .asDriver(onErrorJustReturn: "")

        input.confirmTrigger
            .withLatestFrom(input.sueContents)
            .withUnretained(self)
            .flatMap { owner, contents in
                owner.createSueUseCase.create(suedUserId: owner.userId, contents: contents)
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, _  in
                Logger.print("신고 완료")
                let alert = TrinapAlert(title: "신고 완료", timeText: nil, subtitle: "신고가 완료되었습니다.")
                alert.addAction(title: "확인", style: .primary) { }
                alert.showAlert(navigationController: owner.coordinator?.navigationController) {
                    Logger.print(owner.coordinator?.navigationController.children)
                    owner.coordinator?.popViewController()
                    Logger.print(owner.coordinator?.navigationController.children)
                }
            })
            .disposed(by: disposeBag)
        
        let isValid = input.sueContents
            .map { contents -> Bool in
                if case let Sue.SueContents.etc(realContents) = contents {
                    if realContents != self.placeholder && !realContents.isEmpty {
                        return true
                    }
                }
                return false
            }
            .asDriver(onErrorJustReturn: false)

        return Output(userName: userName, isValid: isValid)
    }
}



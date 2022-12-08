//
//  BlockListViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/07.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class BlockListViewModel: ViewModelType {
    
    struct Input {
        let viewWillappear: Observable<Void>
        let updateBlockStatus: Observable<(Bool, Block.BlockedUser)>
        let backButtonTap: Signal<Void>
    }
    
    struct Output {
        var blockUsers: Driver<[Block.BlockedUser]>
    }
    
    // MARK: - Properties
    private let fetchBlockUsersUseCase: FetchBlockUsersUseCase
    private let createBlockUseCase: CreateBlockUseCase
    private let removeBlockUseCase: RemoveBlockUseCase
    weak var coordinator: MyPageCoordinator?
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(
        coordinator: MyPageCoordinator?,
        fetchBlockUsersUseCase: FetchBlockUsersUseCase,
        createBlockUseCase: CreateBlockUseCase,
        removeBlockUseCase: RemoveBlockUseCase
    ) {
        self.coordinator = coordinator
        self.fetchBlockUsersUseCase = fetchBlockUsersUseCase
        self.createBlockUseCase = createBlockUseCase
        self.removeBlockUseCase = removeBlockUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.updateBlockStatus
            .withUnretained(self)
            .flatMap { owner, blockInfo -> Single<Void> in
                let (isBlocked, block) = blockInfo
                return isBlocked ? owner.removeBlockUseCase.removeBlockUser(blockId: block.blockId) : owner.createBlockUseCase.create(blockedUserId: block.blockedUser.userId, blockId: block.blockId)
            }
            .subscribe(onNext: {
                Logger.print("업데이트 성공!")
            })
            .disposed(by: disposeBag)
        
        input.backButtonTap
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        let blockUsers = input.viewWillappear
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.fetchBlockUsersUseCase.fetchBlockUsers()
            }
            .asDriver(onErrorJustReturn: [])
        return Output(blockUsers: blockUsers)
    }
}

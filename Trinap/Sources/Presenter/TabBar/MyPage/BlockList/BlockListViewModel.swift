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
            .filter { isBlock, _ in
                return isBlock
            }
            .map { _, blockUser in
                return blockUser
            }
            .withUnretained(self)
            .flatMap { owner, blockUser in
                return owner.removeBlockUseCase.removeBlockUser(blockId: blockUser.blockId)
            }
            .subscribe(onNext: {
                Logger.print("삭제 성공!")
            })
            .disposed(by: disposeBag)
        
        input.updateBlockStatus
            .filter { isBlock, _ in
                return !isBlock
            }
            .map { _, blockUser in
                return blockUser
            }
            .withUnretained(self)
            .flatMap { owner, blockUser in
                return owner.createBlockUseCase.create(
                    blockedUserId: blockUser.blockedUser.userId,
                    blockId: blockUser.blockId
                )
            }
            .subscribe(onNext: {
                Logger.print("삭제 취소!")
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

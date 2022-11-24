//
//  PhotographerListViewModel.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class PhotographerListViewModel: ViewModelType {
    
    struct Input {
        // searchTrigger -> 화면 전환
        // 검색어 다 치고 다시 돌어왔을 때 값 받아서 검색어에 저장 <- 얘를 어떻게 해야하지..?
        // 필터 고를 때마다 필터 값 저장
        let searchTrigger: Observable<Void>
        var coordinate: Observable<Coordinate?>
        var tagType: Observable<TagType>
        var searchText: BehaviorRelay<String>
    }

    struct Output {
        var previews: Driver<[PhotographerPreview]>
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let previewsUseCase: FetchPhotographerPreviewsUseCase

    // MARK: - Initializer
    init(
        previewsUseCase: FetchPhotographerPreviewsUseCase,
        coordinator: MainCoordinator
    ) {
        self.previewsUseCase = previewsUseCase
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        input.searchTrigger
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.showSearchViewController(searchText: input.searchText)
            })
            .disposed(by: disposeBag)
        
        let previews = Observable.combineLatest(
            input.coordinate,
            input.tagType
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
        )
            .withUnretained(self)
            .flatMap { (owner, val) -> Observable<[PhotographerPreview]> in
                let (coordinate, type) = val
                return owner.previewsUseCase.fetch(coordinate: coordinate, type: type)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(previews: previews)
    }
}

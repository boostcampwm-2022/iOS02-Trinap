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
        let searchTrigger: Observable<Void>
//        var coordinate: Observable<Coordinate?>
//        var tagType: Observable<TagType>
        var tagType: Observable<TagType>
//        var searchText: BehaviorRelay<String>
    }

    struct Output {
        var previews: Driver<[PhotographerPreview]>
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let previewsUseCase: FetchPhotographerPreviewsUseCase
    
    var searchText = BehaviorRelay<String>(value: "")
    var coordinate = BehaviorRelay<Coordinate?>(value: nil)

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
//        coordinate
//            .subscribe(onNext: { print("야!@#!@#!@#!@!#\($0)")})
//            .disposed(by: disposeBag)
//        input.tagType.do(onNext: {})
//        input.tagType
//            .drive(onNext: { print($0)})
//            .disposed(by: disposeBag)
        
        input.searchTrigger
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.coordinator?.showSearchViewController(
                    searchText: self.searchText,
                    coordinate: self.coordinate
                )
            })
            .disposed(by: disposeBag)
        
        //TODO: tagtype 초기 값이 .all로 설정이 안돼서 coordinate가 들어와도 실행이 되지 않는 상황
        let previews = Observable.combineLatest(
            self.coordinate,
            input.tagType.startWith(.all)
//                .debounce(.seconds(1), scheduler: MainScheduler.instance)
        )
            .withUnretained(self)
            .flatMap { (owner, val) -> Observable<[PhotographerPreview]> in
                let (coordinate, type) = val
                print("와 여기까지 들어와? \(val)")
                return owner.previewsUseCase.fetch(coordinate: coordinate, type: type)
            }
            .debug()
            .map { i -> [PhotographerPreview] in
                print("패치됨. \(i)")
                return i
            }
            .debug()
            .asDriver(onErrorJustReturn: [])
        
        return Output(previews: previews)
    }
}

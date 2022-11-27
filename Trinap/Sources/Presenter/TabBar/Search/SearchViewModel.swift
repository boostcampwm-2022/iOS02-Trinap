//
//  SearchViewModel.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    struct Input {
        var searchText: Observable<String>
        var selectedSpace: Observable<Space>
    }
    
    struct Output {
        var spaces: Driver<[Space]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let searchLocationUseCase: SearchLocationUseCase
    
    weak var searchText: BehaviorRelay<String>?
    weak var coordinate: BehaviorRelay<Coordinate?>?
    // MARK: - Initializer
    init(
        searchLocationUseCase: SearchLocationUseCase,
        coordinator: MainCoordinator,
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) {
        self.searchLocationUseCase = searchLocationUseCase
        self.coordinator = coordinator
        self.searchText = searchText
        self.coordinate = coordinate
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let spaces = input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMap { owner, value in
                owner.searchLocationUseCase.fetchSearchList(with: value)
            }
            .asDriver(onErrorJustReturn: [])
        
        input.selectedSpace
            .withUnretained(self)
            .subscribe(onNext: { owner, space in
                Logger.print("쨔스! \(space) 선택됨")
                // searchText를 space.address로 바꿔주고 popviewcontroller
                owner.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        guard let coordinate else { return Output(spaces: spaces) }
        input.selectedSpace
            .map { Coordinate(lat: $0.lat, lng: $0.lng) }
            .bind(to: coordinate)
        
        return Output(spaces: spaces)
    }
}

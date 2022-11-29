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
        var currentLocationTrigger: Observable<Void>
    }
    
    struct Output {
        var spaces: Driver<[Space]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let searchLocationUseCase: SearchLocationUseCase
    private let currentLocationUseCase: FetchCurrentLocationUseCase
    
    weak var searchText: BehaviorRelay<String>?
    weak var coordinate: BehaviorRelay<Coordinate?>?
    // MARK: - Initializer
    init(
        searchLocationUseCase: SearchLocationUseCase,
        fetchCurrentLocationUseCase: FetchCurrentLocationUseCase,
        coordinator: MainCoordinator,
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) {
        self.searchLocationUseCase = searchLocationUseCase
        self.currentLocationUseCase = fetchCurrentLocationUseCase
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
        
        input.currentLocationTrigger
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.searchText?.accept("현위치")
                owner.coordinator?.popViewController()
            })
            .flatMap { owner, _ -> Observable<(Coordinate, String)> in
                owner.currentLocationUseCase.fetchCurrentLocation()
            }
            .bind(onNext: { [weak self] coor, text in
                guard let self else { return }
                self.searchText?.accept(text)
                self.coordinate?.accept(coor)
            })
            .disposed(by: disposeBag)
        
        input.selectedSpace
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.coordinator?.popViewController()
            })
            .map { _, space -> Coordinate in
                Coordinate(lat: space.lat, lng: space.lng)
            }
            .bind(to: coordinate)
            .disposed(by: disposeBag)
        
        return Output(spaces: spaces)
    }
}

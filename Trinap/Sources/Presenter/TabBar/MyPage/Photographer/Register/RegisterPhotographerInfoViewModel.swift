//
//  RegisterPhotographerInfoViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

final class RegisterPhotographerInfoViewModel: ViewModelType {
    
    struct Input {
        let location: Observable<Space?>
        let locationTrigger: Observable<Void>
        let tags: Observable<[TagType]>
        let price: Observable<Int>
        let introduction: Observable<String>
        let applyTrigger: Observable<Void>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let location: Observable<Space>
        let tagItems: Observable<[TagItem]>
        let price: Observable<Int>
        let introduction: Observable<String>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    weak var coordinator: RegisterPhotographerInfoCoordinator?
    
    private let fetchPhotographerUseCase: FetchPhotographerUseCase
    private let editPhotographerUseCase: EditPhotographerUseCase
    private let mapRepository: MapRepository
    
    lazy var searchText = BehaviorRelay<String>(value: placeholder)
    let coordinate = BehaviorRelay<Coordinate?>(value: nil)
    let placeholder = "지역을 선택해주세요."
    
    // MARK: - Initializer
    init(
        coordinator: RegisterPhotographerInfoCoordinator,
        fetchPhotographerUseCase: FetchPhotographerUseCase,
        editPhotographerUseCase: EditPhotographerUseCase,
        mapRepository: MapRepository
    ) {
        self.coordinator = coordinator
        self.fetchPhotographerUseCase = fetchPhotographerUseCase
        self.editPhotographerUseCase = editPhotographerUseCase
        self.mapRepository = mapRepository
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        let photographer = self.fetchPhotographerUseCase
            .fetch(photographerUserId: nil)
            .share()
        
        let location = photographer
            .withUnretained(self)
            .flatMap { owner, photographer in
                owner.mapRepository
                    .fetchLocationName(
                        using: Coordinate(
                            lat: photographer.latitude,
                            lng: photographer.longitude)
                    )
                    .map { Space(name: $0, address: $0, lat: photographer.latitude, lng: photographer.longitude) }
            }
            .share()
        
        
        let tagItems = photographer
            .map { $0.tags }
            .map { tag in
                TagType.allCases.filter { $0 != .all }.map { type in
                    TagItem(tag: type, isSelected: tag.contains(type))
                }
            }
        
        let price = photographer.map { $0.pricePerHalfHour }
        let introduction = photographer.map { $0.introduction }
        
        let paramters = Observable.combineLatest(input.location, input.tags, input.price, input.introduction)
            .share()
        
        input.applyTrigger.withLatestFrom(paramters)
            .flatMap { location, tags, price, introduction in
                photographer.map { photographer in
                    return Photographer(
                        photographerId: photographer.photographerId,
                        photographerUserId: photographer.photographerUserId,
                        introduction: introduction,
                        latitude: location?.lat ?? photographer.latitude,
                        longitude: location?.lng ?? photographer.longitude,
                        tags: tags.isEmpty ? [.all] : tags,
                        pictures: photographer.pictures,
                        pricePerHalfHour: price,
                        possibleDate: photographer.possibleDate)
                }
            }
            .flatMap { self.editPhotographerUseCase.updatePhotographer(photographer: $0) }
            .subscribe(onNext: {
                self.coordinator?.dismissViewController()
            })
            .disposed(by: disposeBag)
        
        input.locationTrigger
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showSearchViewController(
                    searchText: owner.searchText,
                    coordinate: owner.coordinate
                )
            })
            .disposed(by: disposeBag)
        
        let isValid = paramters.map { space, _, _, introduction in
            return !introduction.isEmpty && space != nil
        }
        
        return Output(
            isValid: isValid,
            location: location,
            tagItems: tagItems,
            price: price,
            introduction: introduction
        )
    }
}

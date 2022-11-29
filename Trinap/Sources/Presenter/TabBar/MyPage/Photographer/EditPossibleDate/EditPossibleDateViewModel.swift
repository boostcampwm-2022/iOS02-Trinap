//
//  EditPossibleDateViewModel.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

final class EditPossibleDateViewModel: ViewModelType {
    
    struct Input {
        let calendarDateTap: Observable<[Date]>
        let editDoneButtonTap: Observable<[Date]>
    }
    
    struct Output {
        let fetchPossibleDate: Observable<[Date]>
        let editDoneButtonEnable: Driver<Bool>
        let editResult: Observable<Void>
    }
    
    // MARK: - Properties
    weak var coordinator: MyPageCoordinator?
    private var editPhotographerUseCase: EditPhotographerUseCase
    private var fetchPhotographerUseCase: FetchPhotographerUseCase
    private var photographer: Photographer?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - Initializer
    init(
        editPhotographerUseCase: EditPhotographerUseCase,
        fetchPhotographerUseCase: FetchPhotographerUseCase
    ) {
        self.editPhotographerUseCase = editPhotographerUseCase
        self.fetchPhotographerUseCase = fetchPhotographerUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let editResult = input.editDoneButtonTap
            .withUnretained(self)
            .flatMap { owner, possibleDate -> Observable<Void> in
                owner.photographer?.possibleDate = possibleDate
                guard let photographer = owner.photographer else {
                    return .error(LocalError.signInError)
                }
                
                return owner.editPhotographerUseCase
                    .updatePhotographer(photographer: photographer)
            }
            
        
        let editDoneButtonEnable = input.calendarDateTap
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let fetchPossibleDate = self.fetchPhotographerUseCase
            .fetch(photographerUserId: nil)
            .withUnretained(self)
            .map { owner, photographer -> [Date] in
                owner.photographer = photographer
                Logger.print(photographer)
                return photographer.possibleDate
            }
        
        return Output(
            fetchPossibleDate: fetchPossibleDate,
            editDoneButtonEnable: editDoneButtonEnable,
            editResult: editResult
        )
    }
}

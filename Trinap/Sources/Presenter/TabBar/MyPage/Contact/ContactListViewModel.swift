//
//  ContactListViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class ContactListViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cellDidSelect: Observable<String>
    }
    
    struct Output {
        let dataSource: Driver<[Contact]>
    }
    
    weak var coordinator: MyPageCoordinator?
    
    var disposeBag = DisposeBag()
    
    private let fetchContactUsUseCase: FetchContactUseCase
    
    init(
        coordinator: MyPageCoordinator?,
        fetchContactUsUseCase: FetchContactUseCase
    ) {
        self.coordinator = coordinator
        self.fetchContactUsUseCase = fetchContactUsUseCase
    }
    
    func transform(input: Input) -> Output {
        input.cellDidSelect
            .withUnretained(self)
            .subscribe(onNext: { owner, contactId in
                owner.coordinator?.showDetailContactViewController(contactId: contactId)
            })
            .disposed(by: disposeBag)
        
        let dataSource = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchContactUsUseCase.fetchContacts()
            }
        
        return Output(dataSource: dataSource.asDriver(onErrorJustReturn: []))
    }
    
    func showAddContactViewController() {
        self.coordinator?.showCreateContactViewController()
    }
}

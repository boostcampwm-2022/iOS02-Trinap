//
//  DetailContactViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift

final class DetailContactViewModel: ViewModelType {
    
    struct Input { }
    
    struct Output {
        let title: Observable<String>
        let contents: Observable<String>
        let date: Observable<String>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private let contactId: String
    private let fetchContactUseCase: FetchContactUseCase
    
    // MARK: - Initializer
    init(
        contactId: String,
        fetchContactUseCase: FetchContactUseCase
    ) {
        self.contactId = contactId
        self.fetchContactUseCase = fetchContactUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        let detailContact = self.fetchContactUseCase.fetchDetailContact(contactId: self.contactId)
            .share()
        
        let title = detailContact.map { $0.title }
        let contents = detailContact.map { $0.description }
        let date = detailContact.map { $0.createdAt }
        
        return Output(
            title: title,
            contents: contents,
            date: date
        )
    }
}

//
//  SearchLocationUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol SearchLocationUseCase {
    
    // MARK: Methods
    func fetchSearchList(with searchText: String) -> Observable<[Space]>
}

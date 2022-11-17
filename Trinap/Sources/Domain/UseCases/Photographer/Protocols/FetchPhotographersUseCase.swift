//
//  FetchPhotographersUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FetchPhotographersUseCase {
    
    // MARK: Methods
    func fetch(type: TagType) -> Observable<[Photographer]>
    //TODO: 지역으로 검색하는 메소드 MapService 구현 후 적용
//    func fetch(filter: String) -> Observable<[Photographer]>
}

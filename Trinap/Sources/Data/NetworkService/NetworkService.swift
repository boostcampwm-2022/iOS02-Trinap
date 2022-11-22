//
//  NetworkService.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol NetworkService {
    
    // MARK: - Methods
    func request(_ endpoint: Endpoint) -> Observable<Data>
}

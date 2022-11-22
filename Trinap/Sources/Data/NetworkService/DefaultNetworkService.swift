//
//  NetworkService.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultNetworkService: NetworkService {
    
    // MARK: - Properties
    private let session: URLSession = .shared
    
    // MARK: - Initializers
    
    // MARK: - Methods

    func request(_ endpoint: Endpoint) -> Observable<Data> {
        guard let urlRequest = endpoint.toURLRequest() else { return .error(NetworkError.invalidURL) }
        
        return URLSession.shared.rx
            .data(request: urlRequest)
            .asObservable()
    }
}

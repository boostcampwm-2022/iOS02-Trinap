//
//  DefaultFetchOpenSourceListUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class DefaultFetchOpenSourceListUseCase: FetchOpenSourceListUseCase {
    
    // MARK: - Properties
    let fetchOpenSourceListRepository: OpenSourceListRepository
    
    // MARK: - Initializers
    init(fetchOpenSourceListRepository: OpenSourceListRepository) {
        self.fetchOpenSourceListRepository = fetchOpenSourceListRepository
    }
    
    // MARK: - Methods
    func fetchOpenSource() -> [OpenSourceInfo] {
        return self.fetchOpenSourceListRepository.fetchOpenSourceList()
            .map { info in
                var mutableInfo = info
                
                mutableInfo.name = info.url?.absoluteString
                    .components(separatedBy: "/")
                    .last?
                    .components(separatedBy: ".")
                    .first ?? info.name
                
                return mutableInfo
            }
    }
}

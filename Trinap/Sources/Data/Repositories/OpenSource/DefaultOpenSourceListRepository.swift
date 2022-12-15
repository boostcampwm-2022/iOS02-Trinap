//
//  DefaultOpenSourceListRepository.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

final class DefaultOpenSourceListRepository: OpenSourceListRepository {

    // MARK: - Methods
    func fetchOpenSourceList() -> [OpenSourceInfo] {
        guard let path = Bundle.main.path(forResource: "OpenSourceList", ofType: "json") else {
            return []
        }
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let openSourceList = try JSONDecoder().decode([OpenSourceInfoDTO].self, from: data)
            return openSourceList.map { $0.toModel() }
        } catch let error {
            print("Json Decode Error: \(error.localizedDescription)")
            return []
        }
    }
}

//
//  FakeUploadImageRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct FakeUploadImageRepository: UploadImageRepository, FakeRepositoryType {
    
    // MARK: - Properties
    var isSucceedCase: Bool
    
    // MARK: - Initializers
    init(isSucceedCase: Bool) {
        self.isSucceedCase = isSucceedCase
    }
    
    // MARK: - Methods
    func upload(image data: Data) -> Observable<String> {
        return execute(successValue: "https://user-images.githubusercontent.com/27603734/200277055-fd64e53e-9901-4e8b-893a-1c028264500e.png")
    }
}

//
//  DefaultUploadImageUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultUploadImageUseCase: UploadImageUseCase {
    
    // MARK: - Properties
    private let uploadImageRepository: UploadImageRepository
    
    // MARK: - Initializer
    init(uploadImageRepository: UploadImageRepository) {
        self.uploadImageRepository = uploadImageRepository
    }
    
    // MARK: - Methods
    func execute(_ imageData: Data) -> Observable<String> {
        return self.uploadImageRepository.upload(image: imageData)
    }
}

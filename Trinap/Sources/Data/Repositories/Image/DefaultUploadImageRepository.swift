//
//  DefaultUploadImageRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultUploadImageRepository: UploadImageRepository {
    
    // MARK: - Properties
    private let firestoreService: FireStoreService
    
    // MARK: - Initializers
    init(firestoreService: FireStoreService = DefaultFireStoreService()) {
        self.firestoreService = firestoreService
    }
    
    // MARK: - Methods
    func upload(image data: Data) -> Observable<String> {
        return self.firestoreService
            .uploadImage(imageData: data)
            .asObservable()
    }
}

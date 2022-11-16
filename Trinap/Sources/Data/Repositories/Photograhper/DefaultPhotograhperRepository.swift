//
//  DefaultPhotograhperRepository.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultPhotographerRepository: PhotographerRepository {
    
    private let firebaseStoreService: FirebaseStoreService
    
    init(firebaseStoreService: FirebaseStoreService) {
        self.firebaseStoreService = firebaseStoreService
    }
    
    func fetchPhotographers(type: TagType) -> Observable<[Photograhper]> {
        
        return firebaseStoreService.getDocument(collection: FireStoreCollectionName.photographers.rawValue)
            .map { $0.compactMap { $0.toObject(type: PhotographerDTO.self)?.toModel() } }
            .asObservable()
    }
    
    func fetchDetailPhotographer(of photograhperId: String) -> Observable<Photograhper> {
        
        return firebaseStoreService.getDocument(
            collection: FireStoreCollectionName.photographers.rawValue,
            document: photograhperId
        )
        .compactMap { $0.toObject(type: PhotographerDTO.self)?.toModel() }
        .asObservable()
    }
    
    func updatePhotograhperInformation(photograhperId: String, with information: Photograhper) -> Observable<Void> {
        
        let values = PhotographerDTO(photograhper: information, status: "active")
        
        guard let data = values.asDictionary else {
            return .error(FireBaseStoreError.unknown)
        }
        
        return firebaseStoreService.updateDocument(
            collection: FireStoreCollectionName.photographers.rawValue,
            document: photograhperId,
            values: data
        )
        .asObservable()
    }
    
    func updatePortfolioPictures(photograhperId: String, with images: [String], image: Data) -> Observable<Void> {
        
        var updateImages = images
        
        return firebaseStoreService.uploadImage(imageData: image)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, url in
                updateImages.append(url)
                let values = ["pictures": updateImages]
                return owner.firebaseStoreService.updateDocument(
                    collection: FireStoreCollectionName.photographers.rawValue,
                    document: photograhperId,
                    values: values
                )
            }
    }
}

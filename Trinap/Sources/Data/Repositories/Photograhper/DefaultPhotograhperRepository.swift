//
//  DefaultPhotograhperRepository.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirestoreService
import RxSwift

final class DefaultPhotographerRepository: PhotographerRepository {
    
    // MARK: Properties
    private let firebaseStoreService: FireStoreService
    private let tokenManager: TokenManager
    
    init(
        firebaseStoreService: FireStoreService,
        tokenManager: TokenManager
    ) {
        self.firebaseStoreService = firebaseStoreService
        self.tokenManager = tokenManager
    }
    
    // MARK: Methods
    func fetchPhotographers(type: TagType) -> Observable<[Photographer]> {
        
        return firebaseStoreService.getDocument(collection: .photographers)
            .map { $0.compactMap { $0.toObject(PhotographerDTO.self)?.toModel() } }
            .asObservable()
    }
    
    //TODO: 지역으로 검색하는 메소드 MapService 구현 후 적용
    
    func fetchDetailPhotographer(of photograhperId: String) -> Observable<Photographer> {
        
        return firebaseStoreService.getDocument(
            collection: .photographers,
            document: photograhperId
        )
        .compactMap { $0.toObject(PhotographerDTO.self)?.toModel() }
        .asObservable()
    }
    
    func create(photographer: Photographer) -> Observable<Void> {
        guard let token = tokenManager.getToken() else {
            return .error(TokenManagerError.notFound)
        }

        var dto = PhotographerDTO(
            photographer: photographer,
            status: .activate
        )
        
        dto.photographerUserId = token
        
        guard let value = dto.asDictionary else { return .error(LocalError.structToDictionaryError) }
        return firebaseStoreService.createDocument(
            collection: .photographers,
            document: photographer.photographerId,
            values: value)
            .asObservable()
    }
    
    func updatePhotograhperInformation(with information: Photographer) -> Observable<Void> {
        
        let values = PhotographerDTO(photographer: information, status: .activate)
        
        guard let data = values.asDictionary else {
            return .error(FireStoreError.unknown)
        }
        
        return firebaseStoreService.updateDocument(
            collection: .photographers,
            document: information.photographerId,
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
                    collection: .photographers,
                    document: photograhperId,
                    values: values
                )
            }
    }
}

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
    private let fireStoreService: FireStoreService
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = KeychainTokenManager()) {
        self.fireStoreService = DefaultFireStoreService()
        self.tokenManager = tokenManager
    }
    
    // MARK: Methods
    func fetchPhotographers(type: TagType) -> Observable<[Photographer]> {
        return fireStoreService.getDocument(collection: .photographers)
            .map { $0.compactMap { $0.toObject(PhotographerDTO.self)?.toModel() } }
            .asObservable()
    }
    
    func fetchPhotographers(ids: [String]) -> Observable<[Photographer]> {
        return fireStoreService.getDocument(collection: .photographers, field: "photographerId", in: ids)
            .map { $0.compactMap { $0.toObject(PhotographerDTO.self)?.toModel() } }
            .asObservable()
    }
    
    func fetchPhotographers(coordinate: Coordinate) -> Observable<[Photographer]> {
        guard let data = coordinate.asDictionary else { return Observable.just([]) }
        return fireStoreService.useFunctions(
            functionName: "nearPhotographer",
            data: data
        )
        .map {
            $0.compactMap { $0.toObject(PhotographerDTO.self)?.toModel() }
        }
        .asObservable()
    }
    
    func fetchDetailPhotographer(of photograhperId: String) -> Observable<Photographer> {
        return fireStoreService.getDocument(
            collection: .photographers,
            document: photograhperId
        )
        .compactMap { $0.toObject(PhotographerDTO.self)?.toModel() }
        .asObservable()
    }
    
    func fetchDetailPhotographer(userId: String) -> Observable<Photographer> {
        return fireStoreService.getDocument(
            collection: .photographers,
            field: "photographerUserId",
            in: [userId]
        )
        .compactMap { $0.first?.toObject(PhotographerDTO.self)?.toModel() }
        .asObservable()
    }
    
    func fetchDetailPhotographer() -> Observable<Photographer> {
        guard let userId = self.tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return fireStoreService.getDocument(
            collection: .photographers,
            field: "photographerUserId",
            in: [userId]
        )
        .compactMap { $0.first?.toObject(PhotographerDTO.self)?.toModel() }
        .asObservable()
    }
    
    func create(photographer: Photographer) -> Observable<Void> {
        guard let token = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }

        var dto = PhotographerDTO(
            photographer: photographer,
            status: .activate
        )
        
        dto.photographerUserId = token
        
        guard let value = dto.asDictionary else { return .error(LocalError.structToDictionaryError) }
        return fireStoreService.createDocument(
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
        
        return fireStoreService.updateDocument(
            collection: .photographers,
            document: information.photographerId,
            values: data
        )
        .asObservable()
    }
    
    func updatePortfolioPictures(photograhperId: String, with images: [String], image: Data) -> Observable<Void> {
        
        var updateImages = images
        
        return fireStoreService.uploadImage(imageData: image)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, url in
                updateImages.append(url)
                let values = ["pictures": updateImages]
                return owner.fireStoreService.updateDocument(
                    collection: .photographers,
                    document: photograhperId,
                    values: values
                )
            }
    }
}

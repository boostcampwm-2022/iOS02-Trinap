//
//  DefaultLocationRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import FirestoreService
import RxSwift

final class DefaultLocationRepository: LocationRepository {
    
    // MARK: - Properties
    private let firestoreService: FireStoreService
    private let tokenManager: TokenManager
    
    // MARK: - Initializers
    init(
        firestoreService: FireStoreService = DefaultFireStoreService(),
        tokenManager: TokenManager = KeychainTokenManager()
    ) {
        self.firestoreService = firestoreService
        self.tokenManager = tokenManager
    }
    
    // MARK: - Methods
    func observe(chatroomId: String) -> Observable<[SharedLocation]> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firestoreService
            .observe(documents: ["chatrooms", chatroomId, "locations"])
            .map { $0.compactMap { $0.toObject(SharedLocation.self) } }
            .map { sharedLocations in
                var mutableSharedLocations: [SharedLocation] = []
                
                sharedLocations.forEach { location in
                    var sharedLocation = location
                    sharedLocation.isMine = (userId == location.userId)
                    
                    mutableSharedLocations.append(sharedLocation)
                }
                return mutableSharedLocations
            }
            .asObservable()
    }
    
    func update(chatroomId: String, location: Coordinate) -> Observable<Void> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let sharedLocation = SharedLocation(userId: userId, latitude: location.lat, longitude: location.lng)
        
        guard let values = sharedLocation.asDictionary else {
            return .error(FireStoreError.unknown)
        }
        
        return self.firestoreService
            .createDocument(
                documents: ["chatrooms", chatroomId, "locations", sharedLocation.userId],
                values: values
            )
            .asObservable()
    }
    
    func endShare(chatroomId: String) -> Observable<Void> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firestoreService
            .deleteDocument(documents: ["chatrooms", chatroomId, "locations", userId])
            .asObservable()
    }
}

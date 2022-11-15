//
//  DefaultFirebaseStoreService.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseCore
import FirebaseFirestore

enum FireBaseStoreError: Error, LocalizedError {
    case unknown
}

final class DefaultFireBaseStoreService: FirebaseStoreService {
    
    typealias FirebaseData = [String: Any]
    
    private let database = Firestore.firestore()
    
    func getDocument(collection: String, document: String) -> Single<FirebaseData> {
        return Single<FirebaseData>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection).document(document).getDocument { snapshot, error in
                
                if let error = error {
                    single(.failure(error))
                }
                
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    single(.failure(FireBaseStoreError.unknown))
                    return
                }
                
                single(.success(data))
            }
            return Disposables.create()
        }
    }
    
    func getDocument(collection: String, field: String, condition: [String]) -> Single<[FirebaseData]> {
        
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection)
                .whereField(field, arrayContains: condition)
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                    }
                    guard let snapshot = snapshot else { single(.failure(FireBaseStoreError.unknown))
                        return
                    }
                    
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            
            return Disposables.create()
        }
    }
    
    /// collection의 모든 값 가져올 때
    func getDocument(collection: String) -> Single<[FirebaseData]> {
        
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection)
                .getDocuments { snapshot, error in
                    
                    if let error = error {
                        print(error)
                        single(.failure(error))
                    }
                    guard let snapshot = snapshot else { single(.failure(FireBaseStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            
            return Disposables.create()
        }
    }
    
    func createDocument(collection: String, document: String, values: FirebaseData) -> Single<Void> {
        
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection)
                .document(document)
                .setData(values) { error in
                    if let error = error {
                        single(.failure(error))
                    }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    func updateDocument(collection: String, document: String, values: FirebaseData) -> Single<Void> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection)
                .document(document)
                .updateData(values) { error in
                    if let error = error {
                        single(.failure(error))
                    }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    func deleteDocument(collection: String, document: String, values: FirebaseData) -> Single<Void> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection)
                .document(document)
                .delete { error in
                    if let error = error {
                        single(.failure(error))
                    }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    func observer(collection: String, document: String) -> Observable<FirebaseData> {
        
        return Observable<FirebaseData>.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection)
                .document(document)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        observable.onError(error)
                    }
                    
                    guard let snapshot = snapshot, let data = snapshot.data() else {
                        observable.onError(FireBaseStoreError.unknown)
                        return
                    }
                    
                    observable.onNext(data)
                }
            return Disposables.create()
        }
    }
}

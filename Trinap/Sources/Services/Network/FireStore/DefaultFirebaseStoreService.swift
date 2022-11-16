//
//  DefaultFirebaseStoreService.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import RxSwift

enum FireBaseStoreError: Error, LocalizedError {
    case unknown
}

final class DefaultFireBaseStoreService: FirebaseStoreService {
    
    // MARK: Properties
    private let database = Firestore.firestore()
    
    // MARK: Methods
    func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData> {
        
        return Single<FirebaseData>.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name).document(document).getDocument { snapshot, error in
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
    
    func getDocument(collection: FireStoreCollection, field: String, condition: [String]) -> Single<[FirebaseData]> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
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
    func getDocument(collection: FireStoreCollection) -> Single<[FirebaseData]> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
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
    
    func getDocument(documents: [String]) -> Single<[String: Any]> {
        
        return Single.create { single in
            
            self.database.document(documents.joined(separator: "/"))
                .getDocument { snapshot, error in
                    
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
    
    func createDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
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
    
    func createDocument(documents: [String], values: FirebaseData) -> Single<Void> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.document(documents.joined(separator: "/"))
                .setData(values) { error in
                    
                    if let error = error {
                        single(.failure(error))
                    }
                    
                    single(.success(()))
                }
            return Disposables.create()
        }
    }

    
    func updateDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
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
    
    func deleteDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
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
    
    func observer(collection: FireStoreCollection, document: String) -> Observable<FirebaseData> {
        
        return Observable<FirebaseData>.create { [weak self] observable in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
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
    
    func observer(documents: [String]) -> Observable<FirebaseData> {
        
        return Observable<FirebaseData>.create { [weak self] observable in
            
            guard let self else { return Disposables.create() }
            
            self.database
                .document(documents.joined(separator: "/"))
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
    
    func uploadImage(imageData: Data) -> Single<String> {
        
        return Single.create { single in
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            
            let firebaseReference = Storage.storage().reference().child("\(imageName)")
            
            firebaseReference.putData(imageData, metadata: metaData) { _, error in
                
                if let error = error {
                    single(.failure(error))
                }
                
                firebaseReference.downloadURL { url, _ in
                    guard let url = url else {
                        single(.failure(FireBaseStoreError.unknown))
                        return
                    }
                    single(.success(url.absoluteString))
                }
            }
            return Disposables.create()
        }
    }
}

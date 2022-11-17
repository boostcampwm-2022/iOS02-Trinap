//
//  DefaultFireStoreService.swift
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

public enum FireStoreError: Error, LocalizedError {
    case unknown
}

public final class DefaultFireStoreService: FireStoreService {
    
    // MARK: Properties
    private let database = Firestore.firestore()
    
    // MARK: Methods
    public func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData> {
        

        return Single<FirebaseData>.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name).document(document).getDocument { snapshot, error in
                if let error = error {
                    single(.failure(error))
                }
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    single(.failure(FireStoreError.unknown))
                    return
                }
                single(.success(data))
            }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, field: String, condition: [String]) -> Single<[FirebaseData]> {
    
        return Single.create { [weak self] single in
    
            guard let self else { return Disposables.create() }
    
            self.database.collection(collection.name)
                .whereField(field, arrayContains: condition)
                .getDocuments { snapshot, error in
    
                    if let error = error {
                        single(.failure(error))
                    }
    
                    guard let snapshot = snapshot else { single(.failure(FireStoreError.unknown))
                        return
                    }
    
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: String, field: String, in values: [Any]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection)
                .whereField(field, in: values)
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                    }
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    /// collection의 모든 값 가져올 때
    public func getDocument(collection: FireStoreCollection) -> Single<[FirebaseData]> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .getDocuments { snapshot, error in
                    
                    if let error = error {
                        single(.failure(error))
                    }
                    
                    guard let snapshot = snapshot else { single(.failure(FireStoreError.unknown))
                        return
                    }
                    
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    // TODO: 아래 getDocument(documents:) -> Single<[String: Any]> 사용하시나요?
    public func getDocument(documents: [String]) -> Single<[String: Any]> {
        
        return Single.create { single in
            
            self.database.document(documents.joined(separator: "/"))
                .getDocument { snapshot, error in
                    
                    if let error = error {
                        single(.failure(error))
                    }
                    
                    guard let snapshot = snapshot, let data = snapshot.data() else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func createDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> {
        
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
    
    public func createDocument(documents: [String], values: FirebaseData) -> Single<Void> {
        
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

    
    public func updateDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> {
        
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
    
    public func deleteDocument(collection: FireStoreCollection, document: String) -> Single<Void> {
        
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
}

// MARK: - Observe
public extension DefaultFireStoreService {
    
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
                        observable.onError(FireStoreError.unknown)
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
                        observable.onError(FireStoreError.unknown)
                        return
                    }
                    
                    observable.onNext(data)
                }
            return Disposables.create()
        }
    }
}
// MARK: - ImageUpload
public extension DefaultFireStoreService {
    
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
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    single(.success(url.absoluteString))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Added
    func getDocuments(documents: [String]) -> Single<[FirebaseData]> {
        return Single.create { single in
            self.database.collection(documents.joined(separator: "/"))
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    func observe(documents: [String]) -> Observable<[FirebaseData]> {
        return Observable.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            self.database
                .collection(documents.joined(separator: "/"))
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        observable.onError(error)
                    }
                    guard let snapshot = snapshot else {
                        observable.onError(FireStoreError.unknown)
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    
                    observable.onNext(data)
                }
            return Disposables.create()
        }
    }
}

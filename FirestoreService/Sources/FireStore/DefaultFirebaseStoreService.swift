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
import FirebaseFunctions
import RxSwift

public enum FireStoreError: Error, LocalizedError {
    case unknown
    case decodeError
}

public final class DefaultFireStoreService: FireStoreService {
    
    // MARK: Properties
    private let database: Firestore
    private lazy var functions = Functions.functions()
    
    // MARK: Methods
    public init(
        firestore: Firestore = Firestore.firestore(),
        allowsCaching: Bool = true
    ) {
        if !allowsCaching {
            let setting = Firestore.firestore().settings
            setting.isPersistenceEnabled = false
            firestore.settings = setting
        }
        
        self.database = firestore
    }
    
    public func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData> {
        return Single<FirebaseData>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name).document(document).getDocument { snapshot, error in
                if let error = error { single(.failure(error)) }
                
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
                    if let error = error { single(.failure(error)) }
    
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
    
    public func getDocument(collection: FireStoreCollection, field: String, in values: [Any]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            var queries = values
            if queries.isEmpty { queries.append("") }
            
            self.database.collection(collection.name)
                .whereField(field, in: queries)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
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
    
    public func getDocument(collection: FireStoreCollection) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
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
    
    public func getDocument(documents: [String]) -> Single<[String: Any]> {
        return Single.create { single in
            self.database.document(documents.joined(separator: "/"))
                .getDocument { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
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
                    if let error = error { single(.failure(error)) }
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
                    if let error = error { single(.failure(error)) }
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
                    if let error = error { single(.failure(error)) }
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
                    if let error = error { single(.failure(error)) }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    public func deleteDocuments(collections: [(FireStoreCollection, String)]) -> Single<Void> {
        let batch = self.database.batch()
        
        collections.forEach { collection, document in
            let document = self.database.collection(collection.name).document(document)
            batch.deleteDocument(document)
        }
        
        return Single.create { single in
            batch.commit { error in
                if let error = error { single(.failure(error)) }
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
                    if let error = error { observable.onError(error) }
                    
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
                    if let error = error { observable.onError(error) }
                    
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
                if let error = error { single(.failure(error)) }
                
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
                    if let error = error { observable.onError(error) }
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
    
    func deleteDocument(documents: [String]) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database
                .document(documents.joined(separator: "/"))
                .delete { error in
                    if let error = error { single(.failure(error)) }
                    
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    func observe(collection: FireStoreCollection, field: String, in values: [Any]) -> Observable<[FirebaseData]> {
        return Observable.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            
            var queries = values
            if queries.isEmpty { queries.append("") }
            
            self.database
                .collection(collection.name)
                .whereField(field, in: queries)
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

// MARK: functions 사용하는 메소드
public extension DefaultFireStoreService {

    func useFunctions(functionName: String, data: FirebaseData) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            self?.functions.httpsCallable(functionName).call(data) { result, error in
                if let error {
                    single(.failure(error))
                    return
                }
                
                guard let data = result?.data as? [FirebaseData] else { return single(.failure(FireStoreError.decodeError))}
                
                single(.success(data))
                return
            }
            return Disposables.create()
        }
    }
}

// MARK: - Leave Chatroom
public extension DefaultFireStoreService {
    
    func deleteChatroom(document: String) -> Single<Void> {
        return self.deleteSubcollection(collection: .chatrooms, document: document, subCollection: "chats")
            .flatMap { [weak self] _ in
                guard let self else { return Single.error(FireStoreError.unknown) }
                
                return self.deleteSubcollection(collection: .chatrooms, document: document, subCollection: "locations")
            }
            .flatMap { [weak self] in
                guard let self else { return Single.error(FireStoreError.unknown) }
                
                return self.deleteDocument(collection: .chatrooms, document: document)
            }
    }
    
    private func deleteSubcollection(collection: FireStoreCollection, document: String, subCollection: String) -> Single<Void> {
        let batch = self.database.batch()
        
        return Single.create { [weak self] result in
            guard let self else { return Disposables.create() }
            
            self.database
                .collection(collection.name)
                .document(document)
                .collection(subCollection)
                .getDocuments { snapshot, error in
                    if let error {
                        result(.failure(error))
                        return
                    }
                    
                    snapshot?.documents.forEach { documentSnapshot in
                        batch.deleteDocument(documentSnapshot.reference)
                    }
                    
                    batch.commit { error in
                        if let error {
                            result(.failure(error))
                            return
                        }
                        
                        result(.success(()))
                    }
                }
            
            return Disposables.create()
        }
    }
}

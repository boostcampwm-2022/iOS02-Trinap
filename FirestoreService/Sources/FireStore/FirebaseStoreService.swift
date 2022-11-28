//
//  FireStoreService.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

public protocol FireStoreService {
    
    typealias FirebaseData = [String: Any]
    
    // MARK: Methods
    func getDocument(collection: FireStoreCollection) -> Single<[FirebaseData]>
    func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData>
    func getDocument(collection: FireStoreCollection, field: String, condition: [String]) -> Single<[FirebaseData]>
    func getDocument(collection: FireStoreCollection, field: String, in values: [Any]) -> Single<[FirebaseData]>
    func getDocument(documents: [String]) -> Single<FirebaseData>
    func createDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    func createDocument(documents: [String], values: FirebaseData) -> Single<Void>
    func updateDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    func deleteDocument(collection: FireStoreCollection, document: String) -> Single<Void>
    func observer(collection: FireStoreCollection, document: String) -> Observable<FirebaseData>
    func observer(documents: [String]) -> Observable<FirebaseData>
    func uploadImage(imageData: Data) -> Single<String>
    
    // MARK: - Added
    func getDocuments(documents: [String]) -> Single<[FirebaseData]>
    func observe(documents: [String]) -> Observable<[FirebaseData]>
    func observe(collection: FireStoreCollection, field: String, in values: [Any]) -> Observable<[FirebaseData]>
    func deleteDocument(documents: [String]) -> Single<Void>
    
    //functions 사용
    func useFunctions(functionName: String, data: FirebaseData) -> Single<[FirebaseData]>
}

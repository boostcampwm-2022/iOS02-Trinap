//
//  FirebaseStoreService.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol FirebaseStoreService {
    
    typealias FirebaseData = [String: Any]
    
    // MARK: Methods
    func getDocument(collection: FireStoreCollection) -> Single<[FirebaseData]>
    func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData>
    func getDocument(collection: FireStoreCollection, field: String, condition: [String]) -> Single<[FirebaseData]>
    func getDocument(documents: [String]) -> Single<FirebaseData>
    func createDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    func createDocument(documents: [String], values: FirebaseData) -> Single<Void>
    func updateDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    func deleteDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    func observer(collection: FireStoreCollection, document: String) -> Observable<FirebaseData>
    func observer(documents: [String]) -> Observable<FirebaseData>
    func uploadImage(imageData: Data) -> Single<String>
}

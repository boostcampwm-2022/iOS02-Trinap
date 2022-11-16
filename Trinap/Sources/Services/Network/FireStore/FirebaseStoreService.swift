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
    
    //MARK: Methods
    func getDocument(collection: String) -> Single<[FirebaseData]>
    func getDocument(collection: String, document: String) -> Single<FirebaseData>
    func getDocument(collection: String, field: String, condition: [String]) -> Single<[FirebaseData]>
    func getDocument(documents: [String]) -> Single<FirebaseData>
    func createDocument(collection: String, document: String, values: FirebaseData) -> Single<Void>
    func createDocument(documents: [String], values: FirebaseData) -> Single<Void>

    func updateDocument(collection: String, document: String, values: FirebaseData) -> Single<Void>
    func deleteDocument(collection: String, document: String, values: FirebaseData) -> Single<Void>
    func observer(collection: String, document: String) -> Observable<FirebaseData>
    func observer(documents: [String]) -> Observable<FirebaseData>
    func uploadImage(imageData: Data) -> Single<String>
}

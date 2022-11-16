//
//  PhotographerRepository.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol PhotographerRepository {
    
    // MARK: Methods
    func fetchPhotographers(type: TagType) -> Observable<[Photograhper]>
    func fetchDetailPhotographer(of photograhperId: String) -> Observable<Photograhper>
    func create(photographer: Photograhper) -> Observable<Void>
    func updatePhotograhperInformation(with information: Photograhper) -> Observable<Void>
    func updatePortfolioPictures(photograhperId: String, with images: [String], image: Data) -> Observable<Void>
}

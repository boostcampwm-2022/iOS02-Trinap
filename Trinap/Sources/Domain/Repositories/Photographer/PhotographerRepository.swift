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
    func fetchPhotographers(type: TagType) -> Observable<[Photographer]>
    func fetchPhotographers(ids: [String]) -> Observable<[Photographer]>
    func fetchPhotographers(coordinate: Coordinate) -> Observable<[Photographer]>
    func fetchDetailPhotographer(of photograhperId: String) -> Observable<Photographer>
    func fetchDetailPhotographer(userId: String) -> Observable<Photographer>
    
    func create(photographer: Photographer) -> Observable<Void>
    func updatePhotograhperInformation(with information: Photographer) -> Observable<Void>
    func updatePortfolioPictures(photograhperId: String, with images: [String], image: Data) -> Observable<Void>
}

//
//  FakePhotographerRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

struct FakePhotographerRepository: PhotographerRepository, FakeRepositoryType {
    
    // MARK: - Properties
    let isSucceedCase: Bool
    
    // MARK: - Initializers
    init(isSucceedCase: Bool = FakeRepositoryEnvironment.isSucceedCase) {
        self.isSucceedCase = isSucceedCase
    }
    
    // MARK: - Methods
    func fetchPhotographers(type: TagType) -> Observable<[Photographer]> {
        var photographers: [Photographer] = []
        
        for i in 1...3 { //Int.random(in: 20...40) {
            let photographer = Photographer.stub(
                photographerId: "photographerId\(i)",
                photographerUserId: "userId\(i)",
                tags: [.all]
            )
            
            photographers.append(photographer)
        }
        
        return execute(successValue: photographers)
    }
    
    func fetchPhotographers(ids: [String]) -> Observable<[Photographer]> {
        var photographers: [Photographer] = []
        
        for id in ids {
            let photographer = Photographer.stub(
                photographerId: "photographerId\(id)",
                photographerUserId: "userId\(id)",
                tags: [.all]
            )
            
            photographers.append(photographer)
        }
        
        return execute(successValue: photographers)
    }
    
    func fetchPhotographers(coordinate: Coordinate) -> Observable<[Photographer]> {
        var photographers: [Photographer] = []
        
        for i in 1...3 { //Int.random(in: 20...40) {
            let photographer = Photographer.stub(
                photographerId: "photographerId\(i)",
                photographerUserId: "userId\(i)",
                tags: [.all]
            )
            
            photographers.append(photographer)
        }
        
        return execute(successValue: photographers)
    }
    
    func fetchDetailPhotographer(of photograhperId: String) -> Observable<Photographer> {
        let photographer = Photographer.stub(photographerId: photograhperId)
        
        return execute(successValue: photographer)
    }
    
    func fetchDetailPhotographer(userId: String) -> Observable<Photographer> {
        let photographer = Photographer.stub(photographerUserId: userId)
        
        return execute(successValue: photographer)
    }
    
    func fetchDetailPhotographer() -> Observable<Photographer> {
        let photographer = Photographer.stub()
        
        return execute(successValue: photographer)
    }
    
    func create(photographer: Photographer) -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func updatePhotograhperInformation(with information: Photographer) -> Observable<Void> {
        return execute(successValue: ())
    }
    
    func updatePortfolioPictures(photograhperId: String, with images: [String], image: Data) -> Observable<Void> {
        return execute(successValue: ())
    }
}

extension Photographer {
    
    static func stub(
        photographerId: String = UUID().uuidString,
        photographerUserId: String = "userId1",
        introduction: String = "사진 작가 소개글입니다. 사진 작가 소개글입니다. 사진 작가 소개글입니다. 사진 작가 소개글입니다. 사진 작가 소개글입니다. 사진 작가 소개글입니다. 사진 작가 소개글입니다. 사진 작가 소개글입니다. ",
        latitude: Double = Coordinate.seoulCoordinate.lat,
        longitude: Double = Coordinate.seoulCoordinate.lng,
        tags: [TagType] = [.all],
        pictures: [String] = [
            "https://media.istockphoto.com/id/1327824636/photo/cherry-blossom-in-spring-at-gyeongbokgung-palace.jpg?b=1&s=170667a&w=0&k=20&c=9u8hQ44fqCwShNu5JmZeNILPB0BHdgVOfRUKu4Ap6s4=",
            "https://media.istockphoto.com/id/521707831/photo/seoul-south-korea-skyline.jpg?s=612x612&w=0&k=20&c=Zlxokjq-Yf_lkGDDReM4SlOXvCebTpFBxZ6b2-MknW8=",
            "https://img.freepik.com/free-photo/gyeongbokgung-palace-night-seoul-korea_335224-476.jpg?w=2000"
        ],
        pricePerHalfHour: Int? = 10000,
        possibleDate: [Date] = [Date()]
    ) -> Photographer {
        return Photographer(
            photographerId: photographerId,
            photographerUserId: photographerUserId,
            introduction: introduction,
            latitude: latitude,
            longitude: longitude,
            tags: tags,
            pictures: pictures,
            pricePerHalfHour: pricePerHalfHour,
            possibleDate: possibleDate
        )
    }
}

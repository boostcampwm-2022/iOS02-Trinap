//
//  LocationRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol LocationRepository {
    
    func observe(chatroomId: String) -> Observable<[SharedLocation]>
    func update(chatroomId: String, location: Coordinate) -> Observable<Void>
}

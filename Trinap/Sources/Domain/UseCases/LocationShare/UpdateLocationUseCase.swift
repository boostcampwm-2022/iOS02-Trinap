//
//  UpdateLocationUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol UpdateLocationUseCase {
    
    func execute(chatroomId: String, location: Coordinate) -> Observable<Void>
}

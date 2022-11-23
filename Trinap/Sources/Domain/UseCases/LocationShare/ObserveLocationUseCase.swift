//
//  ObserveLocationUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol ObserveLocationUseCase {
    
    func execute(chatroomId: String) -> Observable<SharedLocation>
}

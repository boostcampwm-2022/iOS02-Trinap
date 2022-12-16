//
//  LeaveChatroomUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol LeaveChatroomUseCase {
    
    func execute(chatroomId: String) -> Observable<Void>
}

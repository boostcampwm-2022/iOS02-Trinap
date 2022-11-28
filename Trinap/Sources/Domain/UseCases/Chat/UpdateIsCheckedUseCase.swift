//
//  UpdateIsCheckedUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol UpdateIsCheckedUseCase {
    
    func execute(chatroomId: String, chatId: String, toState state: Bool) -> Observable<Void>
}

//
//  EndLocationShareUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol EndLocationShareUseCase {
    
    func execute(chatroomId: String) -> Observable<Void>
}

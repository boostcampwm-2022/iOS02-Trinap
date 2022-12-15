//
//  ObserveChatUseCase.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol ObserveChatUseCase {
    
    // MARK: - Methods
    func execute(chatroomId: String) -> Observable<[Chat]>
}

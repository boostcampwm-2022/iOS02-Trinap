//
//  FetchBlockUsersUseCase.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/03.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
// TODO: blocks 보고 신고당한 아이 user 받아와서 user 배열로 return
import RxSwift

protocol FetchBlockUsersUseCase {

    // MARK: Methods
    func fetchBlockUsers() -> Observable<[User]>
}

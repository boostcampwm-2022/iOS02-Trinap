//
//  EditUserUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol EditUserUseCase {
    func updateProfielInfo(profileImage: String?, nickName: String?) -> Observable<Void>
    func fetchRandomNickName() -> Observable<String>
    func updatePhotographerExposure(_ isOn: Bool) -> Observable<Void>
}

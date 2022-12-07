//
//  DefaultEditUserUseCase.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultEditUserUseCase: EditUserUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func updateProfielInfo(profileImage: String?, nickName: String?) -> Observable<Void> {
        return userRepository.update(profileImage: profileImage, nickname: nickName, isPhotographer: nil)
    }
    
    func fetchRandomNickName() -> Observable<String> {
        return userRepository.createRandomNickname()
    }
    
    func updatePhotographerExposure(_ isOn: Bool) -> Observable<Void> {
        return userRepository.updatePhotographerExposure(value: isOn)
    }
}

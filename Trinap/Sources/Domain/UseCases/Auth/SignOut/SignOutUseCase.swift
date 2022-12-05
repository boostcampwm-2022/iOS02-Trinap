//
//  SignOutUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol SignOutUseCase {
    
    // MARK: - Methods
    func signOut() -> Observable<Bool>
}

//
//  DropOutUseCase.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/12/01.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol DropOutUseCase {
    
    // MARK: - Methods
    func dropOut() -> Observable<Bool>
}

//
//  ViewModelType.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import RxSwift

protocol ViewModelType: AnyObject {
    
    associatedtype Input
    associatedtype Output
    
    // MARK: - Properties
    var disposeBag: DisposeBag { get }
    
    // MARK: - Methods
    func transform(input: Input) -> Output
}

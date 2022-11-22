//
//  UploadImageRepository.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol UploadImageRepository {
    
    func upload(image data: Data) -> Observable<String>
}

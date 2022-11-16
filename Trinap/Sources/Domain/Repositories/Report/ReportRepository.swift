//
//  ReportRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

protocol ReportRepository {
    
    // MARK: Methods
    func reportUser(reportInfo: Report) -> Single<Void>
}

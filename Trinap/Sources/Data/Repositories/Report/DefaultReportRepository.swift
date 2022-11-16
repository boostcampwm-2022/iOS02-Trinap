//
//  DefaultReportRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/16.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultReportRepository: ReportRepository {
    
    enum ReportStatus: String {
        case active
        case inactive
    }
    
    // MARK: Properties
    let firebase: FireStoreService
    
    init(fireStoreService: FireStoreService) {
        self.firebase = fireStoreService
    }
    
    // MARK: Methods
    func reportUser(reportInfo: Report) -> Single<Void> {
        let dto = ReportDTO(
            report: reportInfo,
            status: ReportStatus.active.rawValue
        )
        
        guard let values = dto.asDictionary else { return Single.just(()) }
        
        return firebase.createDocument(
            collection: .blocks,
            document: reportInfo.blockId,
            values: values
        )
    }
}

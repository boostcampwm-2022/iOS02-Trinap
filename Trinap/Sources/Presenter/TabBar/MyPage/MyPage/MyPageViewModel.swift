//
//  MyPageViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

typealias MyPageDataSource = [MyPageSection: [MyPageCellType]]

final class MyPageViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let fetchUserUseCase: FetchUserUseCase
    
    struct Input { }
    
    struct Output {
        let dataSource: Driver<[MyPageDataSource]>
    }
    
    init(fetchUserUseCase: FetchUserUseCase) {
        self.fetchUserUseCase = fetchUserUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let profile = generateProfile().map { [$0] }
        
        let rowData = Observable.of([
            generatePhotograhperSettings(),
            generateUserSettings(),
            generateEtc()
        ])
        
        let dataSource = Observable.zip(profile, rowData)
            .map { $0.0 + $0.1 }
            .asDriver(onErrorJustReturn: [])
        
        dataSource.drive { data in
            print(data)
        }
        
        return Output(dataSource: dataSource)
    }
}

extension MyPageViewModel {
    private func generateProfile() -> Observable<MyPageDataSource> {
        
        return fetchUserUseCase.fetchUserInfo()
            .map { user -> MyPageDataSource in
                [.profile: [MyPageCellType.profile(user: user)]]
            }
    }
    
    private func generatePhotograhperSettings() -> MyPageDataSource {
        let data: [MyPageCellType] = [
            MyPageCellType.phohographerProfile,
            MyPageCellType.photographerDate,
            MyPageCellType.photographerExposure(isExposure: true)
        ]
        
        return [.photograhper: data]
    }
    
    private func generateUserSettings() -> MyPageDataSource {
        let data: [MyPageCellType] = [
            .userAlarm,
            .userImageAuthorization,
            .userLocation,
            .userBlock
        ]
        
        return [.setting: data]
    }
    
    private func generateEtc() -> MyPageDataSource {
        let version = getVerson() ?? "1.0.0"
        
        let data: [MyPageCellType] = [
            .contact,
            .version(version: version),
            .opensource,
            .logout,
            .dropout
        ]
        
        return [.etc: data]
    }
    
    private func getVerson() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {
            return nil
        }
        return version
    }
}

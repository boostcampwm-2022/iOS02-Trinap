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
    private let signOutUseCase: SignOutUseCase
    weak var coordinator: MyPageCoordinator?
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let cellDidSelect: Observable<MyPageCellType>
    }
    
    struct Output {
        let dataSource: Driver<[MyPageDataSource]>
    }
    
    init(
        fetchUserUseCase: FetchUserUseCase,
        signOutUseCase: SignOutUseCase,
        coordinator: MyPageCoordinator?
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.signOutUseCase = signOutUseCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.cellDidSelect
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
                switch type {
                case .signOut:
                    owner.coordinator?.showSignOutAlert(completion: owner.signOut)
                default:
                    owner.coordinator?.showNextView(state: type)
                }
            })
            .disposed(by: disposeBag)
        
        let dataSource = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.generateDataSource()
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(dataSource: dataSource)
    }
}

extension MyPageViewModel {
    
    private func generateDataSource() -> Observable<[MyPageDataSource]> {
        let profile = generateProfile().map { [$0] }
        
        let rowData = Observable.of([
            generatePhotograhperSettings(),
            generateUserSettings(),
            generateEtc()
        ])
        
        return Observable.zip(profile, rowData)
            .map { $0.0 + $0.1 }
    }
    
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
            .nofiticationAuthorization,
            .photoAuthorization,
            .locationAuthorization,
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
            .signOut,
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
    
    private func signOut() {
        return self.signOutUseCase.signOut()
            .withUnretained(self)
            .subscribe(onNext: { owner, isSignOut in
                if isSignOut {
                    owner.coordinator?.finish()
                }
            })
            .disposed(by: disposeBag)
    }
}

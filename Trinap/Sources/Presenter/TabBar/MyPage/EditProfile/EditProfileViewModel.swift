//
//  EditProfileViewModel.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxSwift

final class EditProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let fetchUserUseCase: FetchUserUseCase
    private let editUserUseCase: EditUserUseCase
    private let uploadImageUseCase: UploadImageUseCase
    
    struct Input {
        let nickname: Observable<String>
        let nicknameTrigger: Observable<Void>
        let profileImage: Observable<Data?>
        let buttonTrigger: Observable<Void>
    }
    
    struct Output {
        let nickName: Observable<String>
        let defaultImage: Observable<URL?>
        let result: Observable<Void>
    }
    
    private lazy var nicknameSubject = PublishSubject<String>()
    private lazy var imageData = BehaviorSubject<Data?>(value: nil)
    
    init(
        fetchUserUseCase: FetchUserUseCase,
        editUserUseCase: EditUserUseCase,
        uploadImageUseCase: UploadImageUseCase
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.editUserUseCase = editUserUseCase
        self.uploadImageUseCase = uploadImageUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let user = fetchUserUseCase
            .fetchUserInfo()
            .share()
        
        user.subscribe(onNext: { [weak self] user in
            self?.nicknameSubject.onNext(user.nickname)
        })
        .disposed(by: disposeBag)
        
        input.nicknameTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.editUserUseCase.fetchRandomNickName()
            }
            .bind(to: nicknameSubject)
            .disposed(by: disposeBag)
        
        input.nickname
            .bind(to: nicknameSubject)
            .disposed(by: disposeBag)
        
        input.profileImage
            .bind(to: imageData)
            .disposed(by: disposeBag)
        
        let result = input.buttonTrigger
            .withLatestFrom(Observable.combineLatest(self.imageData.asObserver(), self.nicknameSubject.asObserver()))
            .withUnretained(self)
            .flatMap { owner, arguments in
                let (image, nickname) = arguments
                return owner.requestUpdate(image: image, nickName: nickname)
            }
        
        return Output(nickName: nicknameSubject, defaultImage: user.map { $0.profileImage }, result: result)
    }
}

extension EditProfileViewModel {
    
    private func requestUpdate(image: Data?, nickName: String) -> Observable<Void> {
        guard let image else {
            return editUserUseCase.updateProfielInfo(profileImage: nil, nickName: nickName)
        }
        
        return uploadImageUseCase.execute(image)
            .withUnretained(self)
            .flatMap { owner, url in
                return owner.editUserUseCase.updateProfielInfo(profileImage: url, nickName: nickName)
            }
    }
}

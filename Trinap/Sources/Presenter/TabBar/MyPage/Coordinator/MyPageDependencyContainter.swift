//
//  MyPageDependencyContainter.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class MyPageDependencyContainter {
    
    // MARK: Properties
    weak var mypageCoordinator: MyPageCoordinator?
    
    // MARK: - Repository
    private let mapRepository: MapRepository
    private let photographerRepository: PhotographerRepository
    private let reviewRepository: ReviewRepository
    private let userRepository: UserRepository
    private let authRepository: AuthRepository
    private let uploadImageRepository: UploadImageRepository
    
    // MARK: Initializers
    init(mypageCoordinator: MyPageCoordinator?) {
        self.mypageCoordinator = mypageCoordinator
        self.photographerRepository = DefaultPhotographerRepository()
        self.mapRepository = DefaultMapRepository()
        self.reviewRepository = DefaultReviewRepository()
        self.userRepository = DefaultUserRepository()
        self.authRepository = DefaultAuthRepository()
        self.uploadImageRepository = DefaultUploadImageRepository()
    }
    
    func makeMyPageViewController() -> MyPageViewController {
        return MyPageViewController(viewModel: makeMyPageViewModel())
    }
    
    func makeEditProfileViewController() -> EditProfileViewController {
        return EditProfileViewController(viewModel: makeEditProfileViewModel())
    }
    
    func makeEditPhotographerViewController() -> EditPhotographerViewController {
        return EditPhotographerViewController(viewModel: makeEditPhotographerViewModel())
    }
    
    
    func makeRegisterPhotographerInfoViewController() -> RegisterPhotographerInfoViewController {
        return RegisterPhotographerInfoViewController(viewModel: makeRegisterPhotographerInfoViewModel())
    }
    
    func makeSearchViewController(
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) -> SearchViewController {
        return SearchViewController(
            viewModel: makeSearchViewModel(
                searchText: searchText,
                coordinate: coordinate)
        )
    }
    
    func makeEditPossibleDateViewController() -> EditPossibleDateViewController {
        return EditPossibleDateViewController(viewModel: makeEditPossibleDateViewModel())
    }
    
    func makeDropOutViewController() -> DropOutViewController {
        return DropOutViewController(viewModel: makeDropOutViewModel())
    }
    
    func makeContactListViewController() -> ContactListViewController {
        return ContactListViewController(viewModel: makeContactListViewModel())
    }
    
    func makeDetailContactViewController(contactId: String) -> DetailContactViewController {
        return DetailContactViewController(viewModel: makeDetailContactViewModel(contactId: contactId))
    }
    
    func makeCreateContactViewController() -> CreateContactViewController {
        return CreateContactViewController(viewModel: makeCreateContactViewModel())
    }
}

private extension MyPageDependencyContainter {
    func makeMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(
            fetchUserUseCase: makeFetchUserUseCase(),
            editUserUseCase: makeEditUseUseCase(),
            signOutUseCase: makeSignOutUseCase(),
            coordinator: mypageCoordinator
        )
    }
    
    func makeEditProfileViewModel() -> EditProfileViewModel {
        return EditProfileViewModel(
            fetchUserUseCase: makeFetchUserUseCase(),
            editUserUseCase: makeEditUseUseCase(),
            uploadImageUseCase: makeUploadImageUseCase()
        )
    }
    
    func makeEditPhotographerViewModel() -> EditPhotographerViewModel {
        return EditPhotographerViewModel(
            fetchUserUseCase: makeFetchUserUseCase(),
            fetchPhotographerUseCase: makeFetchPhotographerUseCase(),
            fetchReviewUseCase: makeFetchReviewUseCase(),
            editPortfolioPictureUseCase: makeEditPortfolioPictureUseCase(),
            uploadImageUseCase: makeUploadImageUseCase(),
            mapRepository: mapRepository)
    }
    
    func makeRegisterPhotographerInfoViewModel() -> RegisterPhotographerInfoViewModel {
        return RegisterPhotographerInfoViewModel(
            coordinator: self.mypageCoordinator,
            fetchPhotographerUseCase: makeFetchPhotographerUseCase(),
            editPhotographerUseCase: makeEditPhotographerUseCase(),
            mapRepository: mapRepository
        )
    }
    
    func makeSearchViewModel(
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) -> SearchViewModel {
        return SearchViewModel(
            searchLocationUseCase: makeSearchLocationUseCase(),
            fetchCurrentLocationUseCase: makeFetchCurrentLocationUseCase(),
            coordinator: self.mypageCoordinator,
            searchText: searchText,
            coordinate: coordinate)
    }
    
    func makeEditPossibleDateViewModel() -> EditPossibleDateViewModel {
        return EditPossibleDateViewModel(
            editPhotographerUseCase: makeEditPhotographerUseCase(),
            fetchPhotographerUseCase: makeFetchPhotographerUseCase(),
            coordinator: self.mypageCoordinator)
    }
    
    func makeDropOutViewModel() -> DropOutViewModel {
        return DropOutViewModel(
            coordinator: self.mypageCoordinator,
            dropOutUseCase: makeDropOutUseCase()
        )
    }
    
    // MARK: - Contact
    func makeContactListViewModel() -> ContactListViewModel {
        return ContactListViewModel(
            coordinator: self.mypageCoordinator,
            fetchContactUsUseCase: self.makeFetchContactUseCase()
        )
    }
    
    func makeDetailContactViewModel(contactId: String) -> DetailContactViewModel {
        return DetailContactViewModel(contactId: contactId, fetchContactUseCase: makeFetchContactUseCase())
    }
    
    func makeCreateContactViewModel() -> CreateContactViewModel {
        return CreateContactViewModel(
            coordinator: self.mypageCoordinator,
            createContactUseCase: DefaultCreateContactUseCase(userRepository: userRepository)
        )
    }
}

// MARK: - UseCase
private extension MyPageDependencyContainter {
    // MARK: - UseCase
    func makeFetchUserUseCase() -> FetchUserUseCase {
        return DefaultFetchUserUseCase(userRepository: userRepository)
    }
    
    func makeEditUseUseCase() -> EditUserUseCase {
        return DefaultEditUserUseCase(userRepository: userRepository)
    }
    
    func makeUploadImageUseCase() -> UploadImageUseCase {
        return DefaultUploadImageUseCase(uploadImageRepository: uploadImageRepository)
    }
    
    func makeFetchPhotographerUseCase() -> FetchPhotographerUseCase {
        return DefaultFetchPhotographerUseCase(photographerRespository: photographerRepository)
    }
    
    func makeEditPhotographerUseCase() -> EditPhotographerUseCase {
        return DefaultEditPhotographerUseCase(photographerRepository: photographerRepository)
    }
    
    func makeFetchReviewUseCase() -> FetchReviewUseCase {
        return DefaultFetchReviewUseCase(
            reviewRepository: reviewRepository,
            userRepository: userRepository,
            photographerRepository: photographerRepository
        )
    }
    
    func makeEditPortfolioPictureUseCase() -> EditPortfolioPictureUseCase {
        return DefaultEditPortfolioPictureUseCase(photographerRepository: photographerRepository)
    }
    
    func makeSearchLocationUseCase() -> SearchLocationUseCase {
        return DefaultSearchLocationUseCase(mapService: mapRepository)
    }
    
    func makeFetchCurrentLocationUseCase() -> FetchCurrentLocationUseCase {
        return DefaultFetchCurrentLocationUseCase(mapRepository: mapRepository)
    }
    
    func makeDropOutUseCase() -> DropOutUseCase {
        return DefaultDropOutUseCase(
            authRepository: authRepository,
            photographerRepository: photographerRepository
        )
    }
    
    func makeSignOutUseCase() -> SignOutUseCase {
        return DefaultSignOutUseCase(authRepository: authRepository)
    }
    
    func makeFetchContactUseCase() -> FetchContactUseCase {
        return DefaultFetchContactUseCase(userRepository: userRepository)
    }
}

//
//  MainDependencyContainer.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import FirestoreService

final class MainDependencyContainer {
    
    // MARK: Properties
    let firestoreService: FireStoreService
    let tokenManager: TokenManager
    let photographerRepository: PhotographerRepository
    let mapRepository: MapRepository
    let reviewRepository: ReviewRepository
    let userRepository: UserRepository
    let reservationRepository: ReservationRepository
    let blockRepository: BlockRepository
    let chatroomRepository: ChatroomRepository
    let chatRepository: ChatRepository
    
    weak var mainCoordinator: MainCoordinator?
    
    // MARK: Initializers
    init(mainCoordinator: MainCoordinator?) {
        self.firestoreService = DefaultFireStoreService()
        self.tokenManager = KeychainTokenManager()
        self.mainCoordinator = mainCoordinator
        self.photographerRepository = DefaultPhotographerRepository()
        self.mapRepository = DefaultMapRepository()
        self.reviewRepository = DefaultReviewRepository()
        self.userRepository = DefaultUserRepository()
        self.reservationRepository = DefaultReservationRepository(firebaseStoreService: firestoreService)
        self.blockRepository = DefaultBlockRepository(fireStoreService: firestoreService, keychainManager: KeychainTokenManager())
        self.chatroomRepository = DefaultChatroomRepository(firebaseStoreService: firestoreService)
        self.chatRepository = DefaultChatRepository(firestoreService: firestoreService)
    }
    
    // MARK: PhotographerPreviewList
    func makePhotographerListViewController() -> PhotographerListViewController {
        let viewModel = makePhotographerListViewModel()
        return PhotographerListViewController(viewModel: viewModel)
    }
    
    private func makePhotographerListViewModel() -> PhotographerListViewModel {
        return PhotographerListViewModel(
            previewsUseCase: makePreviewsUseCase(),
            fetchCurrentLocationUseCase: makeFetchCurrentLocationUseCase(),
            coordinator: mainCoordinator
        )
    }
    
    private func makePreviewsUseCase() -> FetchPhotographerPreviewsUseCase {
        return DefaultFetchPhotographerPreviewsUseCase(
            photographerRepository: photographerRepository,
            mapRepository: mapRepository,
            userRepository: userRepository,
            reviewRepository: reviewRepository
        )
    }
    
    private func makeFetchCurrentLocationUseCase() -> FetchCurrentLocationUseCase {
        return DefaultFetchCurrentLocationUseCase(mapRepository: mapRepository)
    }
    
}

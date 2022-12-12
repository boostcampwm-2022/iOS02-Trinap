//
//  PhotographerDetailDependencyContainer.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/08.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation
import FirestoreService

final class PhotographerDetailDependencyContainer {
    
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
    
    weak var photographerDetailCoordinator: PhotographerDetailCoordinator?
    
    // MARK: Initializers
    init(photographerDetailCoordinator: PhotographerDetailCoordinator?) {
        self.firestoreService = DefaultFireStoreService()
        self.tokenManager = KeychainTokenManager()
        self.photographerDetailCoordinator = photographerDetailCoordinator
        self.photographerRepository = DefaultPhotographerRepository()
        self.mapRepository = DefaultMapRepository()
        self.reviewRepository = DefaultReviewRepository()
        self.userRepository = DefaultUserRepository()
        self.reservationRepository = DefaultReservationRepository(firebaseStoreService: firestoreService)
        self.blockRepository = DefaultBlockRepository(fireStoreService: firestoreService, keychainManager: KeychainTokenManager())
        self.chatroomRepository = DefaultChatroomRepository(firebaseStoreService: firestoreService)
        self.chatRepository = DefaultChatRepository(firestoreService: firestoreService)
    }
    
    // MARK: PhotographerDetail
    func makePhotographerDetailViewController(
        userId: String,
        searchCoordinate: Coordinate
    ) -> PhotographerDetailViewController {
        let viewModel = makePhotographerDetailViewModel(
            userId: userId,
            searchCoordinate: searchCoordinate
        )
        return PhotographerDetailViewController(viewModel: viewModel)
    }
    
    private func makePhotographerDetailViewModel(
        userId: String,
        searchCoordinate: Coordinate
    ) -> PhotographerDetailViewModel {
        return PhotographerDetailViewModel(
            fetchUserUseCase: makeFetchUserUseCase(),
            fetchPhotographerUseCase: makeFetchPhotographerUseCase(),
            fetchReviewUseCase: makeFetchReviewUseCase(),
            createReservationUseCase: makeCreateReservationUseCase(),
            createBlockUseCase: makeCreateBlockUseCase(),
            createChatroomUseCase: makeCreateChatRoomUseCase(),
            sendFirstChatUseCase: makeSendFirstChatUseCase(),
            mapRepository: mapRepository,
            userId: userId,
            searchCoordinate: searchCoordinate,
            coordinator: photographerDetailCoordinator
        )
    }
    
    private func makeFetchUserUseCase() -> FetchUserUseCase {
        return DefaultFetchUserUseCase(userRepository: userRepository)
    }
    
    private func makeFetchPhotographerUseCase() -> FetchPhotographerUseCase {
        return DefaultFetchPhotographerUseCase(photographerRespository: photographerRepository)
    }
    
    private func makeFetchReviewUseCase() -> FetchReviewUseCase {
        return DefaultFetchReviewUseCase(
            reviewRepository: reviewRepository,
            userRepository: userRepository,
            photographerRepository: photographerRepository
        )
    }
    
    private func makeCreateReservationUseCase() -> CreateReservationUseCase {
        return DefaultCreateReservationUseCase(reservationRepository: reservationRepository)
    }
    
    private func makeCreateBlockUseCase() -> CreateBlockUseCase {
        return DefaultCreateBlockUseCase(blockRepository: blockRepository)
    }
    
    private func makeCreateChatRoomUseCase() -> CreateChatroomUseCase {
        return DefaultCreateChatroomUseCase(chatroomRepository: chatroomRepository)
    }
    
    private func makeSendFirstChatUseCase() -> SendFirstChatUseCase {
        return DefaultSendFirstChatUseCase(chatRepository: chatRepository)
    }
    
    // MARK: - 신고하기 뷰
    func makeSueViewController(userId: String) -> SueViewController {
        return SueViewController(viewModel: makeSueViewModel(userId: userId))
    }
    
    private func makeSueViewModel(userId: String) -> SueViewModel {
        return SueViewModel(
            userId: userId,
            createSueUseCase: makeCreateSueUseCase(),
            fetchUserUseCase: makeFetchUserUseCase(),
            coordinator: photographerDetailCoordinator
        )
    }
    
    private func makeCreateSueUseCase() -> CreateSueUseCase {
        return DefaultCreateSueUseCase(sueRepository: DefaultSueRepository(fireStoreService: firestoreService, keychainManager: tokenManager))
    }
}

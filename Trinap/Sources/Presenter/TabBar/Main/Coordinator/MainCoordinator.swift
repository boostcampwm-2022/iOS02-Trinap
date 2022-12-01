//
//  MainCoordinator.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxRelay
import FirestoreService

final class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Methods
    func start() {
        self.showPhotographerListViewController()
    }
}

extension MainCoordinator {
    
    func showPhotographerListViewController() {
        let viewController = PhotographerListViewController(
            viewModel: PhotographerListViewModel(
                previewsUseCase: DefaultFetchPhotographerPreviewsUseCase(
                    photographerRepository: DefaultPhotographerRepository(),
                    mapRepository: DefaultMapRepository(),
                    userRepository: DefaultUserRepository(),
                    reviewRepository: DefaultReviewRepository()),
                fetchCurrentLocationUseCase: DefaultFetchCurrentLocationUseCase(
                    mapRepository: DefaultMapRepository()
                ),
                coordinator: self
            ))
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    // TODO: - ViewModel Delegate Setting
    func showSelectReservationDateViewController(with possibleDate: [Date], detailViewModel: PhotographerDetailViewModel) {
        let viewModel = SelectReservationDateViewModel(
            createReservationDateUseCase: DefaultCreateReservationDateUseCase(),
            coordinator: self,
            with: possibleDate
        )
        
        viewModel.delegate = detailViewModel
        
        let viewController = SelectReservationDateViewController(
            viewModel: viewModel
        )
                
        self.navigationController.present(viewController, animated: true)
    }
    
    func showSearchViewController(
        searchText: BehaviorRelay<String>,
        coordinate: BehaviorRelay<Coordinate?>
    ) {
        let viewModel = SearchViewModel(
            searchLocationUseCase: DefaultSearchLocationUseCase(
                mapService: DefaultMapRepository()
            ),
            fetchCurrentLocationUseCase: DefaultFetchCurrentLocationUseCase(
                mapRepository: DefaultMapRepository()
            ),
            coordinator: self,
            searchText: searchText,
            coordinate: coordinate
        )
        let viewController = SearchViewController(
            viewModel: viewModel
        )
        
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false

    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        
    }
    
    func showDetailPhotographerViewController(userId: String, searchCoordinate: Coordinate) {
        let viewModel = PhotographerDetailViewModel(
            fetchUserUseCase: DefaultFetchUserUseCase(
                userRepository: DefaultUserRepository()
            ),
            fetchPhotographerUseCase: DefaultFetchPhotographerUseCase(
                photographerRespository: DefaultPhotographerRepository()
            ),
            fetchReviewUseCase: DefaultFetchReviewUseCase(
                reviewRepositry: DefaultReviewRepository(),
                userRepository: DefaultUserRepository(),
                photographerRepository: DefaultPhotographerRepository()
            ),
            createReservationUseCase: DefaultCreateReservationUseCase(
                reservationRepository: DefaultReservationRepository(
                    firebaseStoreService: DefaultFireStoreService()
                )
            ),
            mapRepository: DefaultMapRepository(),
            userId: userId,
            searchCoordinate: searchCoordinate,
            coordinator: self
        )
        let viewController = PhotographerDetailViewController(
            viewModel: viewModel
        )
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
    }
}

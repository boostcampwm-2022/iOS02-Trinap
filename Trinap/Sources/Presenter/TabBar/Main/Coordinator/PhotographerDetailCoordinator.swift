//
//  PhotographerDetailCoordinator.swift
//  Trinap
//
//  Created by kimchansoo on 2022/12/08.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class PhotographerDetailCoordinator: Coordinator {
    
    // MARK: Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private lazy var dependencies = PhotographerDetailDependencyContainer(photographerDetailCoordinator: self)
    
    private var searchCoordinate: Coordinate?
    private var userId: String?
    
    // MARK: Initializers
    //TODO: 이거 가리려면 어떻게...?
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    convenience init(
        userId: String,
        searchCoordinate: Coordinate,
        navigationController: UINavigationController
    ) {
        self.init(navigationController)
        self.userId = userId
        self.searchCoordinate = searchCoordinate
    }

    // MARK: Methods
    func start() {
        guard
            let userId,
            let searchCoordinate
        else { return }
        
        self.showDetailPhotographerViewController(userId: userId, searchCoordinate: searchCoordinate)
    }
    
    func showDetailPhotographerViewController(userId: String, searchCoordinate: Coordinate) {

        let viewController = dependencies.makePhotographerDetailViewController(
            userId: userId,
            searchCoordinate: searchCoordinate
        )

        self.navigationController.isNavigationBarHidden = false
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
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
    
    func showDetailImageView(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else {
            Logger.print("가드 걸림")
            return
        }
        Logger.print("가드안걸림")
        let viewController = DetailImageViewController()
        viewController.configureImageView(url: url)
        viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(viewController, animated: false)
    }
    
    func showSueController(suedUserId: String) {
        Logger.print("sueController 만들어서 띄워주기")
        let viewController = dependencies.makeSueViewController(userId: suedUserId)
        self.navigationController.pushViewController(viewController, animated: false)
    }
}

//
//  LocationShareViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

final class LocationShareViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var mapView = MKMapView().than {
        $0.showsUserLocation = true
    }
    
    private lazy var currentLocationButton = TrinapButton(style: .primary, isCircle: true).than {
        $0.setImage(UIImage(systemName: "location.fill"), for: .normal)
        $0.tintColor = TrinapAsset.white.color
    }
    
    // MARK: - Properties
    private let viewModel: LocationShareViewModel
    
    // MARK: - Initializers
    init(viewModel: LocationShareViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentLocation = mapView.userLocation
        self.updateLocation(currentLocation, animated: true)
    }
    
    override func configureHierarchy() {
        self.view
            .addSubviews([mapView, currentLocationButton])
    }
    
    override func configureConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(50)
            make.width.height.equalTo(40)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
    }
    
    override func bind() {
        let willChangeRegionWithScroll = mapView.rx
            .regionWillChange
            .filter { !$0 }
            .map { _ in return }
        
        let input = LocationShareViewModel.Input(
            didTapCurrentLocation: currentLocationButton.rx.tap.asSignal(),
            willChangeRegionWithScroll: willChangeRegionWithScroll.asSignal(onErrorJustReturn: ())
        )
        
        let output = viewModel.transform(input: input)
        
        let isFollowCurrentLocation = output.isFollowCurrentLocation.share()
        
        mapView.rx.didUpdateUserLocation
            .withLatestFrom(isFollowCurrentLocation) { (location: $0, isFollow: $1) }
            .filter { $0.isFollow }
            .bind(onNext: { [weak self] location, _ in self?.updateLocation(location) })
            .disposed(by: disposeBag)
        
        isFollowCurrentLocation
            .map { $0 ? TrinapButton.ColorType.primary : .black }
            .bind(to: currentLocationButton.rx.style)
            .disposed(by: disposeBag)
    }
}

private extension LocationShareViewController {
    
    func updateLocation(_ location: MKUserLocation, animated: Bool = true) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        
        mapView.setRegion(region, animated: animated)
    }
}

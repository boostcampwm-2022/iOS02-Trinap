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
    private lazy var myAnnotationView = TrinapAnnotationView().than {
        $0.isMine = true
    }
    
    private lazy var otherAnnotationView = TrinapAnnotationView().than {
        $0.isMine = false
    }
    
    private lazy var mapView = MKMapView().than {
        $0.register(TrinapAnnotationView.self)
        $0.addAnnotation(myAnnotationView)
        $0.addAnnotation(otherAnnotationView)
        $0.delegate = self
    }
    
    private lazy var locationManager = CLLocationManager().than {
        $0.startUpdatingLocation()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.endLocationShare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentLocation = mapView.userLocation.coordinate
        self.moveCameraToCoordinate(currentLocation, animated: true)
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
            make.width.height.equalTo(50)
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
        
        let myCoordinate = locationManager.rx
            .didUpdateLocations
            .compactMap(\.last)
            .map { Coordinate(lat: $0.coordinate.latitude, lng: $0.coordinate.longitude) }
        
        let input = LocationShareViewModel.Input(
            didTapCurrentLocation: currentLocationButton.rx.tap.asSignal(),
            willChangeRegionWithScroll: willChangeRegionWithScroll.asSignal(onErrorJustReturn: ()),
            myCoordinate: myCoordinate
        )
        
        let output = viewModel.transform(input: input)
        
        let isFollowCurrentLocation = output.isFollowCurrentLocation.share()
        
        locationManager.rx.didUpdateLocations
            .compactMap(\.last)
            .withLatestFrom(isFollowCurrentLocation) { (location: $0, isFollow: $1) }
            .filter { $0.isFollow }
            .bind(onNext: { [weak self] location, _ in self?.moveCameraToCoordinate(location.coordinate) })
            .disposed(by: disposeBag)
        
        isFollowCurrentLocation
            .map { $0 ? TrinapButton.ColorType.primary : .black }
            .bind(to: currentLocationButton.rx.style)
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard
                    let self = self,
                    let currentLocation = self.locationManager.location
                else { return }
                
                self.moveCameraToCoordinate(currentLocation.coordinate)
            })
            .disposed(by: disposeBag)
        
        output.myCoordinate
            .compactMap { $0 }
            .bind(onNext: { [weak self] coordinate in self?.updateMyAnnotation(to: coordinate) })
            .disposed(by: disposeBag)
        
        output.otherCoordinate
            .compactMap { $0 }
            .bind(onNext: { [weak self] coordinate in self?.updateOtherAnnotation(to: coordinate) })
            .disposed(by: disposeBag)
    }
}

// MARK: - Privates
private extension LocationShareViewController {
    
    func moveCameraToCoordinate(_ coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        guard !(coordinate.latitude == .zero) else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: animated)
    }
    
    func updateMyAnnotation(to coordinate: Coordinate) {
        updateAnnotation(to: coordinate, annotationView: myAnnotationView)
    }
    
    func updateOtherAnnotation(to coordinate: Coordinate) {
        updateAnnotation(to: coordinate, annotationView: otherAnnotationView)
    }
    
    func updateAnnotation(to coordinate: Coordinate, annotationView: TrinapAnnotationView) {
        annotationView.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lng)
    }
}

// MARK: - MapView Delegate
extension LocationShareViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard
            let annotationView = mapView.dequeueAnnotationView(TrinapAnnotationView.self),
            let annotation = annotation as? TrinapAnnotationView
        else {
            return nil
        }
        
        if annotation.isMine {
            annotationView.image = TrinapAsset.customerPin.image
        } else {
            annotationView.image = TrinapAsset.photographerPin.image
        }
        return annotationView
    }
}

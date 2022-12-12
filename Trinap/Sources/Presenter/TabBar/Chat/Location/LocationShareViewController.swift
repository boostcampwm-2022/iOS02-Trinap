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
    
    private lazy var trackingMeButton = LocationTrackButton(userType: .mine)
    private lazy var trackingOtherButton = LocationTrackButton(userType: .other)
    
    // MARK: - Properties
    private let viewModel: LocationShareViewModel
    
    // MARK: - Initializers
    init(viewModel: LocationShareViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.endLocationShare()
    }
    
    override func configureHierarchy() {
        self.view
            .addSubviews([mapView, trackingMeButton, trackingOtherButton])
    }
    
    override func configureConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        trackingOtherButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-64)
        }
        
        trackingMeButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(trackingOtherButton.snp.top).offset(-16)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        let appearance = UINavigationBarAppearance()
        let backButtonImage = UIImage(systemName: "arrow.left.circle.fill")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)

        appearance.configureWithTransparentBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func bind() {
        let myCoordinate = locationManager.rx
            .didUpdateLocations
            .compactMap(\.last)
            .map { Coordinate(lat: $0.coordinate.latitude, lng: $0.coordinate.longitude) }
        
        let input = LocationShareViewModel.Input(
            didTapTrackingMe: trackingMeButton.rx.tap.asSignal().startWith(()),
            didTapTrackingOther: trackingOtherButton.rx.tap.asSignal(),
            willChangeRegionWithScroll: willChangeRegionWithScroll(),
            myCoordinate: myCoordinate
        )
        
        let output = viewModel.transform(input: input)
        
        let userTypeBeingTracked = output.userTypeBeingTracked
        
        updateMyAnnotation(to: output.myCoordinate)
        updateOtherAnnotation(to: output.otherCoordinate)
        handleLocationTrackButtonStatus(userTypeBeingTracked)
        moveCamera(
            myCoordinate: output.myCoordinate,
            otherCoordinate: output.otherCoordinate,
            userTypeBeingTracked: userTypeBeingTracked
        )
    }
}

// MARK: - Privates
private extension LocationShareViewController {
    
    func willChangeRegionWithScroll() -> Signal<Void> {
        return mapView.rx
            .regionWillChange
            .filter { !$0 }
            .map { _ in return }
            .asSignal(onErrorJustReturn: ())
    }
    
    func moveCameraToCoordinate(_ coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        guard !(coordinate.latitude == .zero) else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: animated)
    }
    
    func updateMyAnnotation(to coordinate: Observable<Coordinate?>) {
        coordinate
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { owner, coordinate in
                owner.updateAnnotation(to: coordinate, annotationView: owner.myAnnotationView)
            })
            .disposed(by: disposeBag)
    }
    
    func updateOtherAnnotation(to coordinate: Observable<Coordinate?>) {
        coordinate
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { owner, coordinate in
                owner.updateAnnotation(to: coordinate, annotationView: owner.otherAnnotationView)
            })
            .disposed(by: disposeBag)
    }
    
    func updateAnnotation(to coordinate: Coordinate, annotationView: TrinapAnnotationView) {
        annotationView.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lng)
    }
    
    func handleLocationTrackButtonStatus(_ userTypeBeingTracked: Observable<LocationShareViewModel.UserType?>) {
        userTypeBeingTracked
            .bind(onNext: { [weak self] userType in
                self?.trackingMeButton.setImage(isTracking: false)
                self?.trackingOtherButton.setImage(isTracking: false)
                
                guard let userType else { return }
                
                switch userType {
                case .mine:
                    self?.trackingMeButton.setImage(isTracking: true)
                case .other:
                    self?.trackingOtherButton.setImage(isTracking: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func moveCamera(
        myCoordinate: Observable<Coordinate?>,
        otherCoordinate: Observable<Coordinate?>,
        userTypeBeingTracked: Observable<LocationShareViewModel.UserType?>
    ) {
        Observable.combineLatest(myCoordinate, otherCoordinate)
            .withLatestFrom(userTypeBeingTracked) { coordinates, userType in
                let (mine, other) = coordinates
                
                switch userType {
                case .mine:
                    return mine
                case .other:
                    return other
                default:
                    return nil
                }
            }
            .compactMap { $0 }
            .map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }
            .bind(onNext: { [weak self] coordinate in
                self?.moveCameraToCoordinate(coordinate)
            })
            .disposed(by: disposeBag)
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

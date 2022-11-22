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
        $0.delegate = self
    }
    
    private lazy var locationManager = CLLocationManager().than {
        $0.delegate = self
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
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
    
    override func configureHierarchy() {
        self.view.addSubviews([mapView])
    }
    
    override func configureConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        
    }
    
    override func bind() {
        
    }
}

// MARK: - MKMapView Delegate
extension LocationShareViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}

// MARK: - LocationShare Delegate
extension LocationShareViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

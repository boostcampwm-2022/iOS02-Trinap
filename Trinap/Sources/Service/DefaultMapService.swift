//
//  DefaultMapService.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit
import Foundation

import RxSwift
import RxRelay

final class DefaultMapService: NSObject, MapService {

    // MARK: Properties
    private let disposebag = DisposeBag()
    private var searchCompleter = MKLocalSearchCompleter()
    private let locationManager = CLLocationManager()
    
    var results = BehaviorRelay<[Space]>(value: [])
    var curCoordinate = PublishRelay<Coordinate>()
    
    // MARK: Initializers
    override init() {
        super.init()
        searchCompleter.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: Methods
    func setSearchText(with searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    private func fetchSelectedLocationInfo(with selectedResult: MKLocalSearchCompletion) -> Single<Space?> {
        
        return Single.create { single in
            let searchRequest = MKLocalSearch.Request(completion: selectedResult)
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                if let error = error {
                    return single(.success(nil))
                }
                
                guard let placeMark = response?.mapItems[0].placemark else {
                    return single(.success(nil))
                }
                
                let coordinate = placeMark.coordinate
                return single(
                    .success(
                        Space(
                            name: selectedResult.title,
                            address: selectedResult.subtitle,
                            lat: coordinate.latitude,
                            lng: coordinate.longitude
                        )))
            }
            return Disposables.create()
        }
    }

}


extension DefaultMapService: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Observable.zip(completer.results.compactMap {
            self.fetchSelectedLocationInfo(with: $0).asObservable()
        })
        .map { locations -> [Space] in
            let filtered = locations.filter { $0 != nil }
            return filtered.compactMap{ $0 }
        }
        .bind(to: results)
        .disposed(by: disposebag)
    }
    

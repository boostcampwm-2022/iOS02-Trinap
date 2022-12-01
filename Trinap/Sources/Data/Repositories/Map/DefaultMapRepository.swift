//
//  DefaultMapRepository.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit
import Foundation

import RxSwift
import RxRelay

final class DefaultMapRepository: NSObject, MapRepository {

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
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }

    // MARK: Methods
    func setSearchText(with searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func fetchCurrentLocation() -> Result<Coordinate, Error> {
        guard let lat = locationManager.location?.coordinate.latitude,
            let lng = locationManager.location?.coordinate.longitude
        else { return  .failure(LocalError.locationAuthError) }
        
        return .success(Coordinate(lat: lat, lng: lng))
    }
    
    func fetchLocationName(using coordinate: Coordinate) -> Observable<String> {
        return Observable.create { observable in
            let location = CLLocation(
                latitude: coordinate.lat,
                longitude: coordinate.lng
            )
            
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                
                guard let address: [CLPlacemark] = placemarks,
                      let locality = address.first?.locality,
                      let subLocality = address.first?.subLocality
                else {
                    observable.onError(LocalError.addressError)
                    return
                }
                
                observable.onNext("\(locality) \(subLocality)")
            }
            return Disposables.create()
        }
    }
    
    private func fetchSelectedLocationInfo(with selectedResult: MKLocalSearchCompletion) -> Single<Space?> {
        
        return Single.create { single in
            let searchRequest = MKLocalSearch.Request(completion: selectedResult)
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard error == nil else {
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

extension DefaultMapRepository: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.curCoordinate.accept(Coordinate(lat: 0.0, lng: 0.0))
        Logger.print(error)
    }
}

extension DefaultMapRepository: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Observable.zip(completer.results.compactMap {
            self.fetchSelectedLocationInfo(with: $0).asObservable()
        })
        .map { locations -> [Space] in
            let filtered = locations.filter { $0 != nil }
            return filtered.compactMap { $0 }
        }
        .bind(to: results)
        .disposed(by: disposebag)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}

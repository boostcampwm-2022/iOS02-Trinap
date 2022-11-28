//
//  MapView+Rx.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit

import RxCocoa
import RxSwift

// MARK: - Reactive Extension
extension Reactive where Base: MKMapView {
    
    var didUpdateUserLocation: Observable<MKUserLocation> {
        RxMKMapViewDelegateProxy.proxy(for: base)
            .currentUserLocation
            .asObservable()
    }
    
    var regionWillChange: Observable<Bool> {
        RxMKMapViewDelegateProxy.proxy(for: base)
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionWillChangeAnimated:)))
            .map { value in
                let animated = try castOrThrow(Int.self, value[1])
                return animated == 1
            }
            .asObservable()
    }
    
    var regionDidChange: Observable<Void> {
        RxMKMapViewDelegateProxy.proxy(for: base)
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { _ in return }
            .asObservable()
    }
    
    private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }
}

// MARK: - Delegate Proxy
final class RxMKMapViewDelegateProxy:
    DelegateProxy<MKMapView, MKMapViewDelegate>,
    DelegateProxyType,
    MKMapViewDelegate {
    
    // MARK: - Properties
    var currentUserLocation = PublishSubject<MKUserLocation>()
    
    // MARK: - Methods
    static func registerKnownImplementations() {
        self.register { mapView in
            RxMKMapViewDelegateProxy(
                parentObject: mapView,
                delegateProxy: RxMKMapViewDelegateProxy.self
            )
        }
    }
    
    static func currentDelegate(for object: MKMapView) -> MKMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: MKMapViewDelegate?, to object: MKMapView) {
        object.delegate = delegate
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        _forwardToDelegate?.mapView(mapView, didUpdate: userLocation)
        currentUserLocation.onNext(userLocation)
    }
}

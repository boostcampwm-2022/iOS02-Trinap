//
//  CLLocationManager+Rx.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import CoreLocation

import RxCocoa
import RxSwift

// MARK: - Reactive Extension
extension Reactive where Base: CLLocationManager {
    
    var didUpdateLocations: Observable<[CLLocation]> {
        RxCLLocationManagerDelegateProxy.proxy(for: base)
            .didUpdateLocations
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
final class RxCLLocationManagerDelegateProxy:
    DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
    DelegateProxyType,
    CLLocationManagerDelegate {
    
    // MARK: - Properties
    lazy var didUpdateLocations = PublishSubject<[CLLocation]>()
    
    // MARK: - Methods
    deinit {
        didUpdateLocations.on(.completed)
    }
    
    static func registerKnownImplementations() {
        self.register { locationManager in
            RxCLLocationManagerDelegateProxy(
                parentObject: locationManager,
                delegateProxy: RxCLLocationManagerDelegateProxy.self
            )
        }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager(manager, didUpdateLocations: locations)
        didUpdateLocations.onNext(locations)
    }
}

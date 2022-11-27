//
//  MKAnnotationView+Reusable.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit

extension MKMapView {
    
    func register<T>(_ annotationViewClass: T.Type) where T: MKAnnotationView {
        self.register(
            annotationViewClass.self,
            forAnnotationViewWithReuseIdentifier: annotationViewClass.reuseIdentifier
        )
    }
    
    func dequeueAnnotationView<T>(_ annotationViewClass: T.Type) -> T? where T: MKAnnotationView {
        return self.dequeueReusableAnnotationView(withIdentifier: T.reuseIdentifier) as? T
    }
}

extension MKAnnotationView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

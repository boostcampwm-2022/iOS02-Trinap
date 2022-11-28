//
//  TrinapAnnotationView.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/25.
//  Copyright © 2022 Trinap. All rights reserved.
//

import MapKit

final class TrinapAnnotationView: MKAnnotationView, MKAnnotation {
    
    // MARK: - Properties
    dynamic var coordinate = CLLocationCoordinate2D()
    var isMine = true
    
    // MARK: - Initializers
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
}

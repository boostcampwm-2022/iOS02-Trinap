//
//  LocationTrackButton.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/08.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class LocationTrackButton: UIButton {
    
    // MARK: - Properties
    private let userType: UserType
    
    private var _isTrackingLocation = false
    var isTrackingLocation: Bool {
        get {
            return _isTrackingLocation
        }
        set {
            self._isTrackingLocation = newValue
            self.setImage(isTracking: newValue)
        }
    }
    
    // MARK: - Initializers
    init(userType: UserType) {
        self.userType = userType
        
        super.init(frame: .zero)
        
        self.setImage(isTracking: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func setImage(isTracking: Bool) {
        let image: UIImage?
        
        if isTracking {
            image = userType.trackedImage
        } else {
            image = userType.untrackedImage
        }
        
        self.setImage(image, for: .normal)
    }
}

// MARK: - UserType
extension LocationTrackButton {
    
    enum UserType {
        case mine
        case other
        
        var trackedImage: UIImage? {
            switch self {
            case .mine:
                return TrinapAsset.customerTracked.image
            case .other:
                return TrinapAsset.photographerTracked.image
            }
        }
        
        var untrackedImage: UIImage? {
            switch self {
            case .mine:
                return TrinapAsset.customerUntracked.image
            case .other:
                return TrinapAsset.photographerUntracked.image
            }
        }
    }
}

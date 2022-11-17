//
//  ProfileImageView.swift
//  TrinapTests
//
//  Created by 김세영 on 2022/11/17.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Queenfisher

final class ProfileImageView: UIImageView {
    
    // MARK: - UI
    
    // MARK: - Properties
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.backgroundColor = TrinapAsset.background.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = self.frame.height / 2
        self.layer.cornerRadius = cornerRadius
    }
    
    func setImage(at profileImageURL: URL?) {
        self.qf.setImage(at: profileImageURL)
    }
}

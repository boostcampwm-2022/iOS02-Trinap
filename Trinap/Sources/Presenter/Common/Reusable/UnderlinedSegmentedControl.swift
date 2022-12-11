//
//  UnderlinedSegmentedControl.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/12.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import Than

final class UnderlinedSegmentedControl: UISegmentedControl {
    
    // MARK: - UI
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let x = CGFloat(self.selectedSegmentIndex * Int(width))
        let y = self.bounds.size.height - 2.0
        let frame = CGRect(x: x, y: y, width: width, height: 2)
        let view = UIView(frame: frame)
        
        view.backgroundColor = TrinapAsset.black.color
        self.addSubview(view)
        return view
    }()
    
    // MARK: - Properties
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = false
        self.removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        self.layer.masksToBounds = false
        self.removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class should not called in Storyboard.")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.bounds.width / CGFloat(self.numberOfSegments)
        let x = CGFloat(self.selectedSegmentIndex * Int(width))
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = x
        }
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}

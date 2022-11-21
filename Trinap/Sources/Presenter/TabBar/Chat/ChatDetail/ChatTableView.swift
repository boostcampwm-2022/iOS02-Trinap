//
//  ChatTableView.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class ChatTableView: UITableView {
    
    // MARK: - Properties
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero, style: .plain)
        
        self.separatorStyle = .none
        self.allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
}

//
//  UITableView+Reusable.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T>(_ cellClass: T.Type) where T: UITableViewCell {
        self.register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
}

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

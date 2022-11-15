//
//  ImageCacheProtocol.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public protocol ImageCacheProtocol {
    
    func fetch(at url: URL, completion: @escaping (QFData?) -> Void)
}

extension ImageCacheProtocol {
    
    func fetchImage(at url: URL, completion: @escaping (QFData?) -> Void) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            completion(data)
        }
    }
}

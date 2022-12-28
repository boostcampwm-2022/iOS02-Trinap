//
//  CacheableImage.swift
//  Queenfisher
//
//  Created by kimchansoo on 2022/12/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public struct CacheableImage: Codable {
    var imageData: QFData
    var etag: String
}

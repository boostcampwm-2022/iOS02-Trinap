//
//  ImageCacheError.swift
//  Queenfisher
//
//  Created by kimchansoo on 2022/12/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum ImageCacheError: Error {
    case imageNotModifiedError
    case httpResponseTransformError
    case unknownError
}

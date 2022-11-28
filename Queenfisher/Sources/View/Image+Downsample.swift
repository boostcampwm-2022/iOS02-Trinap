//
//  Image+Downsample.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension QFData {
    
    public func imageWithDownsampling(to targetSize: CGSize, scale: CGFloat = 1) -> QFImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, imageSourceOptions) else { return nil }
        
        let maxDimension = Swift.max(targetSize.width, targetSize.height) * scale
        let downsamplingOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsamplingOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}

public extension QFImage {
    
    func downsampling(to targetSize: CGSize, scale: CGFloat = 1) -> QFImage {
        return self.jpegData(compressionQuality: 1)?
            .imageWithDownsampling(to: targetSize, scale: scale) ?? self
    }
}

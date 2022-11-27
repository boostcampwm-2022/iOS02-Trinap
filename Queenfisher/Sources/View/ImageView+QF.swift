//
//  ImageView+QF.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

extension QueenfisherWrapper where Base: QFImageView {
    
    public func setImage(
        at url: URL?,
        placeholder: QFImage? = nil,
        indicator: QFIndicator? = QFIndicator(),
        cachePolicy: ImageCache.Policy? = .memory,
        downsampling: Bool = true,
        targetSize: CGSize? = nil,
        scale: CGFloat = 1.5,
        completion: ((CGSize) -> Void)? = nil
    ) {
        guard let url else {
            base.image = placeholder
            return
        }
        
        startIndicator(indicator)
        let maybeCache = imageCache(policy: cachePolicy)
        
        maybeCache.fetch(at: url) { data in
            DispatchQueue.main.async {
                defer { self.stopIndicator(indicator) }
                completion?(.zero)
                
                guard let data else {
                    base.image = placeholder
                    completion?(base.image?.size ?? .zero)
                    return
                }
                
                if downsampling {
                    self.base.image = data.imageWithDownsampling(
                        to: targetSize ?? self.base.frame.size,
                        scale: scale
                    )
                } else {
                    self.base.image = UIImage(data: data)
                }
                
                completion?(self.base.image?.size ?? .zero)
            }
        }
    }
    
    private func startIndicator(_ indicator: QFIndicator?) {
        guard let indicator else { return }
        
        indicator.removeFromSuperview()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.base.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.base.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: self.base.trailingAnchor),
            indicator.topAnchor.constraint(equalTo: self.base.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: self.base.bottomAnchor)
        ])
        
        indicator.startAnimating()
    }
    
    private func stopIndicator(_ indicator: QFIndicator?) {
        indicator?.stopAnimating()
        indicator?.removeFromSuperview()
    }
    
    private func imageCache(policy: ImageCache.Policy?) -> ImageCacheProtocol {
        guard let policy else { return NoImageCache() }
        
        return ImageCache.policy(policy)
    }
}

private final class NoImageCache: ImageCacheProtocol {
    
    func fetch(at url: URL, completion: @escaping (Data?) -> Void) {
        self.fetchImage(at: url, completion: completion)
    }
}

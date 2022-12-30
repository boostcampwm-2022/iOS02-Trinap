//
//  ImageView+QF.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

private var imageTaskKey: Void?

extension QueenfisherWrapper where Base: QFImageView {
    // MARK: UI
    
    // MARK: Properties
    private var imageTask: URLSessionDataTask? {
        get { return getAssociatedObject(base, &imageTaskKey) }
        set { setRetainedAssociatedObject(base, &imageTaskKey, newValue)}
    }
    
    // MARK: Methods
    public func setImage(
        at url: URL?,
        placeholder: QFImage? = nil,
        indicator: QFIndicator? = QFIndicator(),
        performance: ConfigType = .normal,
        downsampling: Bool = true,
        targetSize: CGSize? = nil,
        scale: CGFloat = 1.5,
        completion: ((CGSize) -> Void)? = nil
    ) {
        guard let url else {
            base.image = placeholder
            return
        }
        var mutableSelf = self
        startIndicator(indicator)
        
        let maybeCache = imageCache(performance: performance)
        // 여기서 dataTask가 nil이 아니다 -> dataTask.resume하면 됨
        // dataTask가 nil이다 -> 그냥 받아온 cacheableImage 가지고 와서 처리해주면 됨
        let dataTask = maybeCache.fetch(at: url) { cacheableImage in
            DispatchQueue.main.async {
                setImageLogic(
                    cacheableImage: cacheableImage,
                    indicator: indicator,
                    placeholder: placeholder,
                    downsampling: downsampling,
                    targetSize: targetSize,
                    scale: scale) { size in
                        completion?(size)
                    }
            }
        }
        guard let dataTask else {
            let image = maybeCache.fetchCached(at: url)
            setImageLogic(
                cacheableImage: image,
                indicator: indicator,
                placeholder: placeholder,
                downsampling: downsampling,
                targetSize: targetSize,
                scale: scale) { size in
                    completion?(size)
                }
            return
        }
        dataTask.resume()
        mutableSelf.imageTask = dataTask
    }
    
    public func cancelDownloadTask() {
        imageTask?.cancel()
    }
    
    private func setImageLogic(cacheableImage: CacheableImage?, indicator: QFIndicator?,  placeholder: QFImage?, downsampling: Bool, targetSize: CGSize?, scale: CGFloat, completion: ((CGSize) -> Void)?) {
        defer { self.stopIndicator(indicator) }
        completion?(.zero)
        
        guard let cacheableImage else {
            base.image = placeholder
            completion?(base.image?.size ?? .zero)
            return
        }
        let data = cacheableImage.imageData
        
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
    
    private func imageCache(performance: ConfigType) -> ImageCacheProtocol {
        return ImageCache.instance(performance: performance)
    }
}

private extension QueenfisherWrapper {
    func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(object, key) as? T
    }

    func setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
        objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


private final class NoImageCache: ImageCacheProtocol {
    
    // MARK: Properties
    private let imageDownloader = ImageDownloader()
    
    // MARK: Methods
    func fetch(at url: URL, completion: @escaping (CacheableImage?) -> Void) -> URLSessionDataTask? {
        let task = self.imageDownloader.fetchImage(at: url, etag: nil) { result in
            switch result {
            case .success(let success):
                completion(success)
                return
            case .failure:
                completion(nil)
                return
            }
        }
        
        return task
    }
    
    func fetchCached(at url: URL) -> CacheableImage? {
        return nil
    }
}

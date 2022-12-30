//
//  ImageDownloader.swift
//  Queenfisher
//
//  Created by kimchansoo on 2022/12/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

final class ImageDownloader {
    
    // MARK: Properties
    
    // MARK: Initializers
    
    // MARK: Methods
    func fetchImage(at url: URL, etag: String?, completion: @escaping (Result<CacheableImage, ImageCacheError>) -> Void) -> URLSessionDataTask {
        
        var urlRequest = URLRequest(url: url)
        
        if let etag = etag {
            urlRequest.addValue(etag, forHTTPHeaderField: "If-None-Match")
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.httpResponseTransformError))
                return
            }
            switch response.statusCode {
            case (200...299):
                guard let data else { completion(.failure(.unknownError)); return }
                let etag = response.allHeaderFields["Etag"] as? String ?? ""
                let image = CacheableImage(imageData: data, etag: etag)
                completion(.success(image))
            case 304:
                completion(.failure(.imageNotModifiedError))
            default:
                completion(.failure(.unknownError))
            }
        }
        
        return dataTask
    }
}

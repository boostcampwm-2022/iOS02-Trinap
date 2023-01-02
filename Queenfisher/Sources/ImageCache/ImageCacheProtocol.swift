//
//  ImageCacheProtocol.swift
//  Queenfisher
//
//  Created by 김세영 on 2022/11/15.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

public protocol ImageCacheProtocol {
    
//    func fetch(at url: URL, etag: String?, completion: @escaping (QFData?) -> Void)
//    func fetch(at url: URL, completion: @escaping (CacheableImage?) -> Void) -> URLSessionDataTask
    func fetchCached(at url: URL) -> CacheableImage?
    func fetch(at url: URL, completion: @escaping (CacheableImage?) -> Void) -> URLSessionDataTask?
}

extension ImageCacheProtocol {

//    func fetchImage(at url: URL, etag: String?, completion: @escaping (Result<CacheableImage, ImageCacheError>) -> Void) {
//        var urlRequest = URLRequest(url: url)
//
//        if let etag = etag {
//            urlRequest.addValue(etag, forHTTPHeaderField: "If-None-Match")
//        }
//
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            guard let response = response as? HTTPURLResponse else {
//                completion(.failure(.httpResponseTransformError))
//                return
//            }
//            switch response.statusCode {
//            case (200...299):
//                guard let data else { completion(.failure(.unknownError)); return }
//                let etag = response.allHeaderFields["Etag"] as? String ?? ""
//                let image = CacheableImage(imageData: data, etag: etag)
//                completion(.success(image))
//            case 304:
//                completion(.failure(.imageNotModifiedError))
//            default:
//                completion(.failure(.unknownError))
//            }
//        }
//    }
}

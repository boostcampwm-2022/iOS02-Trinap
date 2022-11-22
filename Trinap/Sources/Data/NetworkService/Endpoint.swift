//
//  Endpoint.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, DELETE
}

typealias HTTPHeaders = [String: String]

// MARK: - Parameter
public enum HTTPRequestParameter {
    
    case query([String: String])
    case body(Encodable)
}

// MARK: - Endpoint
protocol Endpoint {
    
    var baseURL: URL? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var path: String { get }
    var parameters: HTTPRequestParameter? { get }
    
    func toURLRequest() -> URLRequest?
}

extension Endpoint {
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    func toURLRequest() -> URLRequest? {
        guard let url = configureURL() else { return nil }
        
        return URLRequest(url: url)
            .setMethod(method)
            .appendingHeaders(headers)
            .setBody(at: parameters)
    }
    
    private func configureURL() -> URL? {
        return baseURL?
            .appendingPath(path)
            .appendingQueries(at: parameters)
    }
}

extension URL {
    
    func appendingPath(_ path: String) -> URL {
        return self.appendingPathComponent(path)
    }
    
    func appendingQueries(at parameter: HTTPRequestParameter?) -> URL? {
        var components = URLComponents(string: self.absoluteString)
        if case .query(let queries) = parameter {
            components?.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        }
       
        return components?.url
    }
}

extension URLRequest {
    
    func setMethod(_ method: HTTPMethod) -> URLRequest {
        var urlRequest = self
        
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    func appendingHeaders(_ headers: HTTPHeaders) -> URLRequest {
        var urlRequest = self
        
        headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }
    
    func setBody(at parameter: HTTPRequestParameter?) -> URLRequest {
        var urlRequest = self
        
        if case .body(let body) = parameter {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        return urlRequest
    }
}

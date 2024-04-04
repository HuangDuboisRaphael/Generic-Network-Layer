//
//  URLRequestBuilder.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 04/04/2024.
//

import Foundation

final class URLRequestBuilder {
    var baseURL: String
    var path: String?
    var method: HTTPMethod = .get
    var headers: [String: Any]?
    var queryItems: [URLQueryItem]?
    var parameters: [String: Any]?
    
    init(with baseURL: String) {
        self.baseURL = baseURL
    }
    
    func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    func set(path: String?) -> Self {
        self.path = path
        return self
    }
    
    func set(headers: [String: Any]?) -> Self {
        self.headers = headers
        return self
    }
    
    func set(queryItems: [URLQueryItem]?) -> Self {
        self.queryItems = queryItems
        return self
    }
    
    func set(parameters: [String: Any]?) -> Self {
        self.parameters = parameters
        return self
    }
    
    func build() throws -> URLRequest {
        // Check url
        guard let url = URL(string: baseURL) else {
            throw APIErrorHandler.badUrl
        }
        // Path
        var request = path != nil ? URLRequest(url: url.appendingPathComponent(path!)) : URLRequest(url: url)
        
        // HttpMethod
        request.httpMethod = method.rawValue
        
        // Headers
        headers?.forEach {
            if let value = $0.value as? String {
                request.addValue(value, forHTTPHeaderField: $0.key)
            }
        }
        
        // Query Items
        if let queryItems = queryItems {
            request.url?.append(queryItems: queryItems)
        }
        
        // Parameters
        if let parameters = parameters {
            request = try encode(request, with: parameters)
        }
        return request
    }
}

extension URLRequestBuilder {
    private func encode(_ request: URLRequest, with parameters: [String: Any]) throws -> URLRequest {
        var request = request
        let jsonAsData = try serializedParameters(parameters)
        request.httpBody = jsonAsData
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    
    func serializedParameters(_ parameters: [String: Any]) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            throw APIErrorHandler.encodingError
        }
    }
}

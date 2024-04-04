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
    
    func set(parameters: [String: Any]?) -> Self {
        self.parameters = parameters
        return self
    }
    
    func build() throws -> URLRequest {
        guard let url = URL(string: baseURL) else {
            throw APIErrorHandler.badUrl
        }
        var request = path != nil ? URLRequest(url: url.appendingPathComponent(path!)) : URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach {
            request.addValue($0.value as? String ?? "", forHTTPHeaderField: $0.key)
        }
        if let parameters = parameters {
            request = try encode(request, with: parameters)
        }
        return request
    }
}

private extension URLRequestBuilder {
    func encode(_ request: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
        do {
            guard let parameters = parameters else { return request }
            var request = request
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonAsData
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            return request
        } catch {
            throw APIErrorHandler.encodingError
        }
    }
}

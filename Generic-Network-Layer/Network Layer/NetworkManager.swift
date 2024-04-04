//
//  NetworkManager.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 02/04/2024.
//

import Foundation

protocol NetworkManagerInterface: AnyObject {
    func performRequest<T>(_ request: URLRequest, decodingType: T.Type) async throws -> T where T: Decodable
}

final class NetworkManager: NetworkManagerInterface {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func performRequest<T: Decodable>(_ request: URLRequest, decodingType: T.Type) async throws -> T {
        var (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            throw APIErrorHandler.transportError
        }
        try validateResponse(response)
        do {
            let decodedData = try JSONDecoder().decode(decodingType, from: data)
            return decodedData
        } catch {
            throw APIErrorHandler.decodingError
        }
    }
}

private extension NetworkManager {
    func validateResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw APIErrorHandler.badRequest
        }
        switch response.statusCode {
        case 200..<300:
            return
        case 400:
            throw APIErrorHandler.badRequest
        case 401:
            throw APIErrorHandler.unauthorized
        case 404:
            throw APIErrorHandler.notFound
        case 408:
            throw APIErrorHandler.requestTimeout
        case 429:
            throw APIErrorHandler.tooManyRequests
        case 500:
            throw APIErrorHandler.serverError
        default:
            throw APIErrorHandler.http(statusCode: response.statusCode)
        }
        
    }
}

//
//  APIErrorHandler.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 03/04/2024.
//

import Foundation

enum APIErrorHandler: Error {
    case noConnection
    case badRequest
    case unauthorized
    case notFound
    case requestTimeout
    case tooManyRequests
    case serverError
    case encodingError
    case decodingError
    case http(statusCode: Int)
}

extension APIErrorHandler: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnection:
            "Check your internet connection."
        case .badRequest, .notFound, . requestTimeout, .encodingError, .decodingError, .serverError, .unauthorized, .tooManyRequests, .http:
            "Contact administrators for further help."
        }
    }
}

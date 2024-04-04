//
//  APIErrorHandler.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 03/04/2024.
//

import Foundation

enum APIErrorHandler: Error, Equatable {
    case noConnection
    case badUrl
    case badRequest
    case transportError
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
        case .badUrl, .notFound, .transportError, .requestTimeout, .encodingError, .decodingError, .serverError, .unauthorized, .tooManyRequests, .http, .badRequest:
            "Contact administrators for further help."
        }
    }
}

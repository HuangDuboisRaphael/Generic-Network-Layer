//
//  CatResourceProvider.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 03/04/2024.
//

import Foundation

enum CatResourceProvider {
    case getAFact
}

extension CatResourceProvider: ApiEndpoint {
    var baseURLString: String {
        return "https://meowfacts.herokuapp.com"
    }
    
    var apiPath: String? { nil }
    var apiVersion: String? { nil }
    var separatorPath: String? { nil }
    var path: String? { nil }
    var headers: [String : String]? { nil }
    var queryForCall: [URLQueryItem]? { nil }
    var parameters: [String : Any]? { nil }
    
    var method: APIHTTPMethod {
        switch self {
        case .getAFact:
                .GET
        }
    }
    
    var customDataBody: Data? { nil }
}

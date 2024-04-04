//
//  CatResourceProvider.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 03/04/2024.
//

import Foundation

enum CatServiceProvider {
    case getAFact
}

extension CatServiceProvider {
    func buildRequest() throws -> URLRequest {
        switch self {
        case .getAFact:
            try URLRequestBuilder(with: ConfigurationApp.API.baseUrl)
                .build()
        }
    }
}

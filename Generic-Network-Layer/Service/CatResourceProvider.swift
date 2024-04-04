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

extension CatResourceProvider {
    func buildRequest() throws -> URLRequest {
        switch self {
        case .getAFact:
            try URLRequestBuilder(with: "https://meowfacts.herokuapp.com/")
                .build()
        }
    }
}

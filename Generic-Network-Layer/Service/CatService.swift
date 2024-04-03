//
//  CatService.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 03/04/2024.
//

import Foundation

protocol CatServiceInterface: AnyObject {
    func getAFact() async throws -> Cat
}

final class CatService: CatServiceInterface {
    private let networkManager: NetworkInterface
    
    init(networkManager: NetworkInterface = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getAFact() async throws -> Cat {
        let request = CatResourceProvider.getAFact.makeRequest
        do {
            return try await networkManager.performRequest(request, decodingType: Cat.self)
        } catch {
            throw error
        }
    }
}

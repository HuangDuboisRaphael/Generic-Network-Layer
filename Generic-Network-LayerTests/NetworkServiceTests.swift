//
//  NetworkServiceTests.swift
//  NetworkServiceTests
//
//  Created by Raphaël Huang-Dubois on 02/04/2024.
//

import XCTest
@testable import Generic_Network_Layer

final class NetworkServiceTests: XCTestCase {
    var networkManager: NetworkManagerInterface!
    var catService: CatServiceInterface!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        networkManager = NetworkManager(urlSession: urlSession)
        catService = CatService(networkManager: networkManager)
    }

    func testParsingResponse() async throws {
        let requestBuilder = URLRequestBuilder(with: "")
        XCTAssertThrowsError(try requestBuilder.build()) { error in
            XCTAssertEqual(error as? APIErrorHandler, APIErrorHandler.badUrl)
        }
    }
}

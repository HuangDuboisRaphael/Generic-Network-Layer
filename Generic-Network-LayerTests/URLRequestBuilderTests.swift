//
//  URLRequestBuilderTests.swift
//  Generic-Network-LayerTests
//
//  Created by Raphaël Huang-Dubois on 04/04/2024.
//

import XCTest
@testable import Generic_Network_Layer

final class URLRequestBuilderTests: XCTestCase {
    var urlRequestBuilder: URLRequestBuilder!

    override func setUpWithError() throws {
        urlRequestBuilder = URLRequestBuilder(with: ConfigurationApp.API.baseUrl)
    }

    func test_methodSet_usingHTTPMethodDelete_shouldApplyHTTPMethodDelete() {
        let request = try? urlRequestBuilder
            .set(method: .delete)
            .build()
        XCTAssertNoThrow(request)
        XCTAssertEqual(
            request?.httpMethod,
            HTTPMethod.delete.rawValue
        )
    }
    
    func test_methodSet_usingPath_shouldAddPath() {
        let path: String = "/path"
        let request = try? urlRequestBuilder
            .set(path: path)
            .build()
        XCTAssertNoThrow(request)
        XCTAssertEqual(
            request?.url?.absoluteString,
            ConfigurationApp.API.baseUrl + path
        )
    }

    func test_methodSet_usingHeader_shouldAddHeader() {
        let headers: [String: Any] = ["Authorization": "12345678"]
        let request = try? urlRequestBuilder
            .set(headers: headers)
            .build()
        XCTAssertNoThrow(request)
        XCTAssertEqual(
            request?.value(forHTTPHeaderField: "Authorization"),
            "12345678"
        )
    }
    
    func test_methodSet_usingQueryItems_shouldAddQuery() {
        let queryItems = [URLQueryItem(name: "api_key", value: "abcdefg")]
        let request = try? urlRequestBuilder
            .set(queryItems: queryItems)
            .build()
        XCTAssertNoThrow(request)
        XCTAssertEqual(
            request?.url?.query(),
            "api_key=abcdefg"
        )
    }
    
    func test_methodSet_usingParameters_shouldAddEncodedParameters() {
        let parameters: [String: Any] = ["parameter": "value"]
        let json = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let request = try? urlRequestBuilder
            .set(parameters: parameters)
            .build()
        XCTAssertNoThrow(request)
        XCTAssertEqual(
            request?.httpBody,
            json
        )
        XCTAssertEqual(
            request?.value(forHTTPHeaderField: "Content-Type"),
            "application/json"
        )
    }
    
    func test_methodSerializedParameters_usingWrongParameters_shouldThrowEncodingError() {
        let unicode = String(
            bytes: [0xD8, 0x00] as [UInt8],
            encoding: String.Encoding.utf16BigEndian
        )!
        XCTAssertThrowsError(try urlRequestBuilder.serializedParameters(["parameters": unicode])) { error in
            XCTAssertEqual(
                error as? APIErrorHandler,
                APIErrorHandler.encodingError
            )
        }
    }
    
    func test_methodBuuild_usingBadUrl_shouldThrowBadUrl() {
        urlRequestBuilder = URLRequestBuilder(with: "")
        XCTAssertThrowsError(try urlRequestBuilder.build()) { error in
            XCTAssertEqual(
                error as? APIErrorHandler,
                APIErrorHandler.badUrl
            )
        }
    }
}

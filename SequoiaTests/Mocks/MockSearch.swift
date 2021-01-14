//
//  MockSearch.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import Foundation
import XCTest
@testable import Sequoia

final class MockSearch: GraphQL {
    private var searches: [(String?, Any)] = []
    
    deinit {
        verify()
    }
    
    func verify() {
        XCTAssertEqual(searches.count, 0)
    }
    
    func expectSearch<T: Codable>(query: String? = nil, result: Result<SearchPage<T>, Error>) {
        searches.append((query, result as Any))
    }
    
    func search<T: Codable>(query: String, completion: @escaping (Result<SearchPage<T>, Error>) -> Void) {
        if let (expectedQuery, result) = searches.first {
            searches.removeFirst()
            if let expectedQuery = expectedQuery {
                XCTAssertEqual(query, expectedQuery)
            }
            completion(result as! Result<SearchPage<T>, Error>)
        } else {
            XCTFail("Unexpected search call on MockSearch")
        }
    }
}

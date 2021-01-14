//
//  SearchData.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation

/// A wrapper object for extracting GraphQL response data
///
/// This is the boilerplate that is on the outer layers of the
/// GraphQL response for searches, so we need to define
/// it so we can parse it and extract the real data (the `T`)
struct SearchData<T: Codable>: Codable {
    var data: Data
}

extension SearchData {
    struct Data: Codable {
        var search: Search
    }
    
    struct Search: Codable {
        var edges: [Edge]
    }
    
    struct Edge: Codable {
        var node: T
        var cursor: String
    }
}



//
//  RepoDetails.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation

/// GitHub Repository Details
struct RepoDetails: Codable, Hashable {
    var id: String
    var name: String
    var url: String
    var description: String?
    var owner: RepoOwner
    var stars: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case description
        case owner
        case stars = "stargazerCount"
    }
}

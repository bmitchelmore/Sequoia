//
//  RepoOwner.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation

struct RepoOwner: Codable, Hashable {
    var name: String
    var avatar: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatar = "avatarUrl"
    }
}

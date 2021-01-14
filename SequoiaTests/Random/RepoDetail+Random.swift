//
//  RepoDetail+Random.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import Foundation
@testable import Sequoia

extension RepoDetails {
    static func random() -> RepoDetails {
        return RepoDetails(
            id: .random(),
            name: .random(),
            url: .random(),
            description: .random(),
            owner: .random(),
            stars: .random(in: 5...5000)
        )
    }
}

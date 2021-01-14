//
//  RepoOwner+Random.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import Foundation
@testable import Sequoia

extension RepoOwner {
    static func random() -> RepoOwner {
        return RepoOwner(
            name: .random(),
            avatar: .random()
        )
    }
}

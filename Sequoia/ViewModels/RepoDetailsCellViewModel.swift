//
//  RepoDetailsCellViewModel.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation
import UIKit

struct RepoDetailsCellViewModel: Hashable {
    var id: String
    var name: String
    var owner: String
    var description: String
    var avatar: UIImage?
    var stars: Int
}
